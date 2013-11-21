//
//  XHFLinearView.m
//  XHFLinearView
//
//  Created by 周方 on 13-9-26.
//  Copyright (c) 2013年 徐恒飞. All rights reserved.
//

#import "XHFLinearView.h"
#import <QuartzCore/QuartzCore.h>



@implementation XHFLinearViewUnit

-(float)height{
    return self.view.bounds.size.height+self.margin.top+self.margin.bottom;
}
@end


@interface XHFLinearView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XHFLinearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemSource=[NSMutableArray array];
        
        self.tableView=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.autoresizesSubviews=YES;
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}
-(void)needLayout{
    [self fitHeight];
    [self.tableView reloadData];
}
-(void)needLayoutForItem:(UIView *)item{
    [self fitHeight];
    NSInteger index=[self indexOfItem:item];
    if(index!=-1){
        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)insertItem:(UIView *)item margin:(XHFMargin)margin atIndex:(NSUInteger)index withAnimation:(XHFLinearItemAnimation)animation{
    [self.itemSource insertObject:XHFLinearViewUnitMake(item, margin) atIndex:index];
    [self.tableView beginUpdates];
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:index];
    [self.tableView insertSections:indexSet withRowAnimation:(UITableViewRowAnimation)animation];
    [self fitHeight];
    [self.tableView endUpdates];
}

-(void)insertItem:(UIView *)item margin:(XHFMargin)margin beforeItem:(UIView *)relativeItem withAnimation:(XHFLinearItemAnimation)animation{
    NSInteger index=[self indexOfItem:relativeItem];
    if(index!=-1){
        [self insertItem:item margin:margin atIndex:index withAnimation:animation];
    }

}
-(void)insertItem:(UIView *)item margin:(XHFMargin)margin afterItem:(UIView *)relativeItem withAnimation:(XHFLinearItemAnimation)animation{
    NSInteger index=[self indexOfItem:relativeItem];
    if(index!=-1){
        [self insertItem:item margin:margin atIndex:index+1 withAnimation:animation];
    }
}
-(void)appendItem:(UIView *)item margin:(XHFMargin)margin withAnimation:(XHFLinearItemAnimation)animation{
    [self.itemSource addObject:XHFLinearViewUnitMake(item, margin)];
    [self.tableView beginUpdates];
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:self.itemSource.count-1];
    [self.tableView insertSections:indexSet withRowAnimation:(UITableViewRowAnimation)animation];
    [self fitHeight];
    [self.tableView endUpdates];
}
-(void)replaceItem:(UIView *)oldItem withNewItem:(UIView *)newItem withAnimation:(XHFLinearItemAnimation)animation{
    NSInteger index=[self indexOfItem:oldItem];
    if(index!=-1){
        XHFLinearViewUnit *old=[self.itemSource objectAtIndex:index];
        [self replaceItem:oldItem withNewItem:newItem withNewMargin:old.margin withAnimation:animation];
    }
}
-(void)replaceItem:(UIView *)oldItem withNewItem:(UIView *)newItem withNewMargin:(XHFMargin)margin withAnimation:(XHFLinearItemAnimation)animation{
    NSInteger index=[self indexOfItem:oldItem];
    if(index!=-1){
        [self.itemSource removeObjectAtIndex:index];
        [self.itemSource insertObject:XHFLinearViewUnitMake(newItem, margin) atIndex:index];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimation)animation];
        [self fitHeight];
        [self.tableView endUpdates];
    }
}

-(void)removeItem:(UIView *)item withAnimation:(XHFLinearItemAnimation)animation{
    NSInteger index=[self indexOfItem:item];
    if(index>=0){
        [self removeItemByIndex:index withAnimation:animation];
    }
}
-(void)removeItemByIndex:(NSInteger)index withAnimation:(XHFLinearItemAnimation)animation{
    [self.itemSource removeObjectAtIndex:index];
    [self.tableView beginUpdates];
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:index];
    [self.tableView deleteSections:indexSet withRowAnimation:(UITableViewRowAnimation)animation];
    [self fitHeight];
    [self.tableView endUpdates];
}


-(void)setScrollEnabled:(BOOL)enable{
    [self.tableView setScrollEnabled:enable];
}
-(BOOL)isScrollEnabled{
    return self.tableView.scrollEnabled;
}
-(void)setBounces:(BOOL)enable{
    self.tableView.bounces=enable;
}
-(BOOL)bounces{
    return self.tableView.bounces;
}


-(NSInteger)indexOfItem:(UIView*)item{
    NSInteger index=-1;
    for(int i=0;i<self.itemSource.count;i++){
        XHFLinearViewUnit *unit=[self.itemSource objectAtIndex:i];
        if(unit.view == item){
            index=i;
            break;
        }
    }
    return index;
}
-(XHFMargin)marginOfItem:(UIView *)item{
    NSInteger index=[self indexOfItem:item];
    if(index!=-1){
        XHFLinearViewUnit *unit=[self.itemSource objectAtIndex:index];
        return unit.margin;
    }
    return XHFMarginZero;
}
-(NSArray *)items{
    NSMutableArray *items=[NSMutableArray arrayWithCapacity:self.itemSource.count];
    for(XHFLinearViewUnit *unit in self.itemSource){
        [items addObject:unit.view];
    }
    return items;
}
#pragma mark -
#pragma mark private methods
-(void)fitHeight{
    if(self.forceFitHeight){
        float totalHeight=0;
        for(XHFLinearViewUnit *unit in self.itemSource){
            totalHeight+=[unit height];
        }
        CGRect frame=self.frame;
        frame.size.height=totalHeight;
        self.frame=frame;
        self.tableView.frame=self.bounds;
    }
}
#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    XHFLinearViewUnit *unit=[self.itemSource objectAtIndex:indexPath.section];
    XHFMargin margin=unit.margin;
    UIView *item=unit.view;
    UIView *outer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, margin.left+margin.right+item.bounds.size.width, margin.top+margin.bottom+item.bounds.size.height)];
    item.frame=CGRectMake(margin.left, margin.top, item.bounds.size.width, item.bounds.size.height);
    [outer addSubview:item];
    [cell addSubview:outer];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHFLinearViewUnit *unit=[self.itemSource objectAtIndex:indexPath.section];
    return unit.view.bounds.size.height+unit.margin.top+unit.margin.bottom;
}

#pragma mark -
#pragma mark Override Methods
-(void)layoutSubviews{
    if(self.forceFitHeight){
        float totalHeight=0;
        for(XHFLinearViewUnit *unit in self.itemSource){
            totalHeight+=[unit height];
        }
        CGRect frame=self.frame;
        frame.size.height=totalHeight;
        self.frame=frame;
    }
        
    [super layoutSubviews];
    
    self.tableView.frame=self.bounds;
}

@end