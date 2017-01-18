//
//  KSBEditAddV.m
//  KenStockBallot
//
//  Created by ken on 15/5/28.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBEditAddV.h"
#import "KSBStockInfo.h"

#import "NSDate+Helpers.h"
#import "VRGCalendarView.h"

static const int itemHeight = 34;

@interface KSBEditAddV ()<VRGCalendarViewDelegate>

@property (assign) BOOL shangHaiSelected;
@property (assign) KSBCalculateType calculateType;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *shangHaiBtn;
@property (nonatomic, strong) UIButton *shengZhenBtn;
@property (nonatomic, strong) NSMutableArray *textFieldArray;
@property (nonatomic, strong, readonly) KSBStockInfo *stockInfo;

@end

@implementation KSBEditAddV

- (instancetype)initWithStock:(KSBStockInfo *)info calculateType:(KSBCalculateType)type {
    self = [super initWithFrame:(CGRect){CGPointZero, kGSize}];
    if (self) {
        _stockInfo = info;
        _calculateType = type;
        if ([KenUtils isNotEmpty:info] && [info.stockJiaoYS isEqual:KenLocal(@"edit_shengzhen")]) {
            _shangHaiSelected = NO;
        } else {
            _shangHaiSelected = YES;
        }
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        //tap gesture
        UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [self addGestureRecognizer:tapTouch];
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    return self;
}

- (void)showContent {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:(CGRect){kGSize.width, (kGSize.height - 310) / 2,
            IsPad ? kGSize.width * 0.34 : kGSize.width * 0.8, 310}];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
//        [[_contentView layer] setBorderWidth:0.2];//画线的宽度
//        [[_contentView layer] setBorderColor:[UIColor darkGrayColor].CGColor];//颜色
        [[_contentView layer] setCornerRadius:8];//圆角
        [[_contentView layer] setMasksToBounds:YES];
        
        [self addSubview:_contentView];
        
        [self initContent];
        
        UIButton *confirmBtn = [KenUtils buttonWithImg:KenLocal(@"qusstion_manual_add") off:0 zoomIn:YES
                                                 image:[UIImage imageNamed:@"confirm_btn.png"]
                                              imagesec:[UIImage imageNamed:@"confirm_btn_sec.png"] target:self action:@selector(confirmClicked)];
        confirmBtn.center = CGPointMake(_contentView.width / 2, _contentView.height - confirmBtn.height * 0.75);
        [_contentView addSubview:confirmBtn];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.frame = (CGRect){IsPad ? kGSize.width * 0.33 : kGSize.width * 0.1, _contentView.originY, _contentView.size};
    }];
}

- (void)initItem:(NSString *)unitStr title:(NSString *)title offY:(float)offY text:(NSString *)text {
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){15, offY, _contentView.width - 30, 1}];
    [line setBackgroundColor:[UIColor grayBgColor]];
    [_contentView addSubview:line];
    
    UILabel *label = [KenUtils labelWithTxt:title frame:(CGRect){15, offY, 100, itemHeight}
                                       font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
    label.textAlignment = KTextAlignmentLeft;
    [_contentView addSubview:label];
    
    //text field
    float width = _contentView.width - 120 - 15;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(120, offY + 4,
                                                                          [KenUtils isEmpty:unitStr] ? width : width - 20, itemHeight - 8)];
    textField.text = text;
    textField.font = kKenFontArial(14);
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.clearsOnBeginEditing = NO;
    textField.textAlignment = KTextAlignmentLeft;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_contentView addSubview:textField];
    
    if (_textFieldArray == nil) {
        _textFieldArray = [NSMutableArray array];
    }
    [_textFieldArray addObject:textField];
    
    //label
    if ([KenUtils isNotEmpty:unitStr]) {
        UILabel *unitLabel = [KenUtils labelWithTxt:unitStr frame:(CGRect){CGRectGetMaxX(textField.frame) + 6, offY, 100, itemHeight}
                                               font:kKenFontHelvetica(16) color:[UIColor blackTextColor]];
        unitLabel.textAlignment = KTextAlignmentLeft;
        [_contentView addSubview:unitLabel];
    }
}

- (void)initContent {
    UIButton *closeBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:YES image:[UIImage imageNamed:@"add_cancel.png"]
                                         imagesec:[UIImage imageNamed:@"add_cancel_sec.png"]
                                           target:self action:@selector(closeView)];
    closeBtn.frame = CGRectMake(_contentView.width - closeBtn.width * 1.8, -closeBtn.width * 1.2, closeBtn.width * 3, closeBtn.height * 3);
    _contentView.clipsToBounds = NO;                //是否切割超出bounds的部分
    [_contentView addSubview:closeBtn];
    [_contentView bringSubviewToFront:closeBtn];
    
    NSArray *array = @[KenLocal(@"edit_title1"), KenLocal(@"edit_title2"), KenLocal(@"edit_title3"), KenLocal(@"edit_title4"),
                       _calculateType == kKSBCalculateQuestion1 ? KenLocal(@"edit_title5_2") : KenLocal(@"edit_title5_2"), KenLocal(@"edit_title6"), KenLocal(@"edit_title7")];
    NSArray *textArray = nil;
    if ([KenUtils isEmpty:_stockInfo]) {
        textArray = @[@"", @"", @"", @"", @"", @"", @""];
    } else {
        textArray = @[@"", [_stockInfo stockName], [_stockInfo stockCode],
                  [NSString stringWithFormat:@"%.2f", _stockInfo.stockPrice],
                  [NSString stringWithFormat:@"%d", (int)_stockInfo.stockBuyMax],
                  [NSString stringWithFormat:@"%.4f", _stockInfo.stockBallot], _stockInfo.stockDate];
    }
    
    float offY = 20;
    for (int i = 0; i < [array count]; i++) {
        if (i == 0) {
            [self initRadioV:offY title:array[i]];
            offY += itemHeight;
        } else {
            NSString *unit = nil;
            if (i == 3) {
                unit = KenLocal(@"edit_yuan");
            } else if (i == 4) {
                unit = KenLocal(@"edit_gu");
            } else if (i == 5) {
                unit = @"%";
            }
            
            [self initItem:unit title:array[i] offY:offY text:[textArray objectAtIndex:i]];
            
            if (i != 1) {
                ((UITextField *)_textFieldArray[i - 1]).keyboardType = UIKeyboardTypeDecimalPad;
            }
            
            offY += itemHeight;
        }
    }
    
    UIButton *button = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:nil imagesec:nil target:self action:@selector(calendarClicked)];
    button.frame = ((UITextField *)[_textFieldArray lastObject]).frame;
    button.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:button];
}

- (void)initRadioV:(float)offY title:(NSString *)title {
    float width = (_contentView.width - 120 - 15) / 2;
    
    UILabel *label = [KenUtils labelWithTxt:title frame:(CGRect){15, offY, 120, 30}
                                       font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
    label.textAlignment = KTextAlignmentLeft;
    [_contentView addSubview:label];
    
    _shangHaiBtn = [KenUtils buttonWithImg:KenLocal(@"edit_shanghai") off:0 zoomIn:YES
                                     image:[UIImage imageNamed:_shangHaiSelected ? @"redio_selected.png" : @"redio_unselected.png"]
                                  imagesec:[UIImage imageNamed:_shangHaiSelected ? @"redio_selected.png" : @"redio_unselected.png"]
                                    target:self action:@selector(shangHaiSelect)];
    [_shangHaiBtn setBackgroundColor:[UIColor whiteColor]];
    [_shangHaiBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
    _shangHaiBtn.frame = CGRectMake(110, offY, width, itemHeight);
    [_contentView addSubview:_shangHaiBtn];
    
    _shengZhenBtn = [KenUtils buttonWithImg:KenLocal(@"edit_shengzhen") off:0 zoomIn:YES
                                      image:[UIImage imageNamed:_shangHaiSelected ? @"redio_unselected.png" : @"redio_selected.png"]
                                   imagesec:[UIImage imageNamed:_shangHaiSelected ? @"redio_unselected.png" : @"redio_selected.png"]
                                     target:self action:@selector(shengZhenSelect)];
    [_shengZhenBtn setBackgroundColor:[UIColor whiteColor]];
    [_shengZhenBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
    _shengZhenBtn.frame = CGRectMake(CGRectGetMaxX(_shangHaiBtn.frame), _shangHaiBtn.originY, width, itemHeight);
    [_contentView addSubview:_shengZhenBtn];
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    for (int i = 0; i < [_textFieldArray count]; i++) {
        if (_textFieldArray[i] == textField) {
            [textField resignFirstResponder];
            
            if (i != [_textFieldArray count] - 1) {
                [[_textFieldArray objectAtIndex:i + 1] becomeFirstResponder];
            }
            break;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    for (int i = 0; i < [_textFieldArray count]; i++) {
//        if (_textFieldArray[i] == textField) {
//            [UIView animateWithDuration:0.3f animations:^{
//                self.frame = CGRectMake(0.f, -60 - i * itemHeight, self.width, self.height);
//            }];
//            break;
//        }
//    }
}

- (void)hideKeyboard {
    [_textFieldArray makeObjectsPerformSelector:@selector(resignFirstResponder)];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0.f, 0, self.width, self.height);
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height + 10;
    int offset = MAX(0, height - (kGSize.height - _contentView.height) / 2);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0.f, -offset, self.width, self.height);
    }];
}

#pragma mark VRGCalendarViewDelegate methods
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}

- (void)calendarCloseView {
    _contentView.hidden = NO;
}

- (void)calendarViewFinishSelect:(VRGCalendarView *)calendarView startDate:(NSDate *)start endDate:(NSDate *)end{
    if ([KenUtils isEmpty:start]) {
        start = [NSDate date];
    }
    if ([KenUtils isEmpty:end]) {
        end = start;
    }
    
    [calendarView removeFromSuperview];
    
    ((UITextField *)[_textFieldArray lastObject]).text = [end dateStringWithFormat:@"yy/MM/dd"];
    
    _contentView.hidden = NO;
}

#pragma mark - button
- (void)calendarClicked {
    VRGCalendarView *calendar = [[VRGCalendarView alloc] initWithParentFrame:(CGRect){0, 0, self.size}];
    calendar.delegate = self;
    calendar.onlyOneDate = YES;
    [self addSubview:calendar];
    
    _contentView.hidden = YES;
}

- (void)closeView {
    if (_contentView) {
        [UIView animateWithDuration:0.5 animations:^{
            _contentView.frame = (CGRect){kGSize.width, _contentView.originY, _contentView.size};
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)shangHaiSelect {
    if (!_shangHaiSelected) {
        _shangHaiSelected = YES;
        
        [_shangHaiBtn setImage:[UIImage imageNamed:@"redio_selected.png"] forState:UIControlStateNormal];
        [_shengZhenBtn setImage:[UIImage imageNamed:@"redio_unselected.png"] forState:UIControlStateNormal];
    }
}

- (void)shengZhenSelect {
    if (_shangHaiSelected) {
        _shangHaiSelected = NO;
        [_shangHaiBtn setImage:[UIImage imageNamed:@"redio_unselected.png"] forState:UIControlStateNormal];
        [_shengZhenBtn setImage:[UIImage imageNamed:@"redio_selected.png"] forState:UIControlStateNormal];
    }
}

- (void)confirmClicked {
    for (int i = 0; i < [_textFieldArray count]; i++) {
        if ([KenUtils isEmpty:[_textFieldArray[i] text]]) {
            NSString *string = [@"edit_alert" stringByAppendingFormat:@"%d", i + 1];
            kKenAlert(KenLocal(string));
            return;
        } else if (i == 3) {
            int base = _shangHaiSelected ? 1000 : 500;
            if ([[_textFieldArray[3] text] integerValue] % base != 0) {
                kKenAlert(_shangHaiSelected ? KenLocal(@"edit_validate_alert4_sh") : KenLocal(@"edit_validate_alert4_sz"));
                return;
            } else {
                if (![KenUtils validateInteger:[_textFieldArray[i] text]]) {
                    NSString *string = [@"edit_validate_alert" stringByAppendingFormat:@"%d", i + 1];
                    kKenAlert(KenLocal(string));
                    return;
                }
            }
        } else if (i == _textFieldArray.count - 1) {
            
        } else if (i >= 2 && ![KenUtils validateNumber:[_textFieldArray[i] text]]){
            NSString *string = [@"edit_validate_alert" stringByAppendingFormat:@"%d", i + 1];
            kKenAlert(KenLocal(string));
            return;
        }
    }
    
    if (_stockInfo) {
        _stockInfo.stockJiaoYS = _shangHaiSelected ? KenLocal(@"edit_shanghai") : KenLocal(@"edit_shengzhen");
        _stockInfo.stockName = [_textFieldArray[0] text];
        _stockInfo.stockCode = [_textFieldArray[1] text];
        _stockInfo.stockPrice = [[_textFieldArray[2] text] floatValue];
        _stockInfo.stockBuyMax = [[_textFieldArray[3] text] integerValue];
        _stockInfo.stockBallot = [[_textFieldArray[4] text] floatValue];
        _stockInfo.stockDate = [_textFieldArray[5] text];
        if (self.editBlock) {
            self.editBlock(_stockInfo);
        }
    } else {
        KSBStockInfo *info = [[KSBStockInfo alloc] init];
        info.stockJiaoYS = _shangHaiSelected ? KenLocal(@"edit_shanghai") : KenLocal(@"edit_shengzhen");
        info.stockName = [_textFieldArray[0] text];
        info.stockCode = [_textFieldArray[1] text];
        info.stockPrice = [[_textFieldArray[2] text] floatValue];
        info.stockBuyMax = [[_textFieldArray[3] text] integerValue];
        info.stockBallot = [[_textFieldArray[4] text] floatValue];
        info.stockDate = [_textFieldArray[5] text];
        if (self.addBlock) {
            self.addBlock(info);
        }
    }
    
    [self closeView];
}
@end
