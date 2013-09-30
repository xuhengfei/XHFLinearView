//
//  XHFLinearView.h
//  XHFLinearView
//
//  Created by xuhengfei on 13-9-26.
//  Copyright (c) 2013年 徐恒飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct XHFMargin {
    CGFloat top, left, bottom, right;
} XHFMargin;

static inline XHFMargin XHFMarginMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    XHFMargin margin = {top, left, bottom, right};
    return margin;
}

#define XHFMarginZero XHFMarginMake(0,0,0,0)

typedef NS_ENUM(NSInteger, XHFLinearItemAnimation) {
    XHFLinearItemAnimationFade,
    XHFLinearItemAnimationRight,           // slide in from right (or out to right)
    XHFLinearItemAnimationLeft,
    XHFLinearItemAnimationTop,
    XHFLinearItemAnimationBottom,
    XHFLinearItemAnimationNone,            // available in iOS 3.0
    XHFLinearItemAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
    XHFLinearItemAnimationAutomatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
};


@interface XHFLinearViewUnit : NSObject

@property (nonatomic,strong) UIView *view;
@property (nonatomic,assign) XHFMargin margin;
-(float)height;
@end

static inline XHFLinearViewUnit *XHFLinearViewUnitMake(UIView *view,XHFMargin margin){
    XHFLinearViewUnit *unit=[[XHFLinearViewUnit alloc]init];
    unit.view=view;
    unit.margin=margin;
    return unit;
}


@interface XHFLinearView : UIView
//自适应高度，默认为NO
@property (nonatomic,assign) BOOL forceFitHeight;
@property (nonatomic,getter=isScrollEnabled) BOOL          scrollEnabled;
@property (nonatomic) BOOL          bounces;
@property (nonatomic,strong,readonly) NSMutableArray *itemSource;//datasource of linearview, type with XHFLinearViewUnit

-(void)needLayout;
-(void)needLayoutForItem:(UIView*)item;

-(void)insertItem:(UIView *)item margin:(XHFMargin)margin atIndex:(NSUInteger)index withAnimation:(XHFLinearItemAnimation)animation;
-(void)insertItem:(UIView *)item margin:(XHFMargin)margin afterItem:(UIView *)relativeItem withAnimation:(XHFLinearItemAnimation)animation;
-(void)insertItem:(UIView *)item margin:(XHFMargin)margin beforeItem:(UIView *)relativeItem withAnimation:(XHFLinearItemAnimation)animation;

-(void)appendItem:(UIView*)item margin:(XHFMargin)margin withAnimation:(XHFLinearItemAnimation)animation;


-(void)replaceItem:(UIView *)oldItem withNewItem:(UIView *)newItem withAnimation:(XHFLinearItemAnimation)animation;
-(void)replaceItem:(UIView *)oldItem withNewItem:(UIView *)newItem withNewMargin:(XHFMargin)margin withAnimation:(XHFLinearItemAnimation)animation;


-(void)removeItem:(UIView *)item withAnimation:(XHFLinearItemAnimation)animation;
-(void)removeItemByIndex:(NSInteger)index withAnimation:(XHFLinearItemAnimation)animation;

-(NSInteger)indexOfItem:(UIView*)item;
-(XHFMargin)marginOfItem:(UIView*)item;
-(NSArray*)items;
@end

