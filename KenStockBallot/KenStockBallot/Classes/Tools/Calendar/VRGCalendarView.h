//
//  VRGCalendarView.h
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"

#define kVRGCalendarViewTopBarHeight        60
#define kVRGCalendarViewBottomBarHeight     50
#define kVRGCalendarViewWidth 320

#define kVRGCalendarViewDayWidth 44
#define kVRGCalendarViewDayHeight 44

@protocol VRGCalendarViewDelegate;
@interface VRGCalendarView : UIView {
    id <VRGCalendarViewDelegate> delegate;
    
    NSDate *currentMonth;
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSArray *markedColors;
}

@property (nonatomic, strong) id <VRGCalendarViewDelegate> delegate;
@property (nonatomic, strong) NSDate *currentMonth;
@property (nonatomic, strong) UIImageView *animationView_A;
@property (nonatomic, strong) UIImageView *animationView_B;
@property (nonatomic, strong) NSArray *markedDates;
@property (nonatomic, strong) NSArray *markedColors;
@property (nonatomic, getter = calendarHeight) CGFloat calendarHeight;
@property (nonatomic, strong, getter = selectedDate) NSDate *selectedDate;


- (instancetype)initWithParentFrame:(CGRect)frame;

-(void)selectDate:(int)date;
-(void)reset;

-(void)markDates:(NSArray *)dates;
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors;

-(void)showNextMonth;
-(void)showPreviousMonth;

-(int)numRows;
-(void)updateSize;
-(UIImage *)drawCurrentState;

@end

@protocol VRGCalendarViewDelegate <NSObject>
- (void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated;
- (void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date;
- (void)calendarViewFinishSelect:(VRGCalendarView *)calendarView startDate:(NSDate *)start endDate:(NSDate *)end;
@end
