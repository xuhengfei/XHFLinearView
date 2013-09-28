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
@property (nonatomic,strong,readonly) NSMutableArray *dataSource;//datasource of linearview, type with XHFLinearViewUnit

-(void)needLayout;
-(void)needLayoutForItem:(UIView*)item;

-(void)insertItem:(UIView *)item margin:(XHFMargin)margin atIndex:(NSUInteger)index withAnimation:(UITableViewRowAnimation)animation;
-(void)insertItem:(UIView *)item margin:(XHFMargin)margin afterItem:(UIView *)relativeItem withAnimation:(UITableViewRowAnimation)animation;
-(void)insertItem:(UIView *)item margin:(XHFMargin)margin beforeItem:(UIView *)relativeItem withAnimation:(UITableViewRowAnimation)animation;

-(void)appendItem:(UIView*)item margin:(XHFMargin)margin withAnimation:(UITableViewRowAnimation)animation;


-(void)replaceItem:(UIView *)oldItem withNewItem:(UIView *)newItem withAnimation:(UITableViewRowAnimation)animation;
-(void)replaceItem:(UIView *)oldItem withNewItem:(UIView *)newItem withNewMargin:(XHFMargin)margin withAnimation:(UITableViewRowAnimation)animation;


-(void)removeItem:(UIView *)item withAnimation:(UITableViewRowAnimation)animation;
-(void)removeItemByIndex:(NSInteger)index withAnimation:(UITableViewRowAnimation)animation;

-(NSInteger)indexOfItem:(UIView*)item;
-(XHFMargin)marginOfItem:(UIView*)item;
-(NSArray*)items;
@end

