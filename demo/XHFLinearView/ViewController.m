//
//  ViewController.m
//  XHFLinearView
//
//  Created by 周方 on 13-9-26.
//  Copyright (c) 2013年 徐恒飞. All rights reserved.
//

#import "ViewController.h"
#import "XHFLinearView.h"

@interface ViewController ()

@property (nonatomic,strong) XHFLinearView *linearView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds=self.view.bounds;
    bounds.size.height=bounds.size.height-50;
    self.linearView=[[XHFLinearView alloc]initWithFrame:CGRectMake(0, 0, 320, 450)];
    
    [self.view addSubview:self.linearView];
    [self.view sendSubviewToBack:self.linearView];
    
    //init 3 items at first
    for(int i=0;i<3;i++){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 20)];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[self randomColor];
        
        [self.linearView.dataSource addObject:XHFLinearViewUnitMake(label, XHFMarginMake(5, 5, 5, 5))];
    }
    [self.linearView needLayout];
}

- (IBAction)insertAction:(id)sender {
    static int num=0;
    UILabel *bar1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 30)];
    bar1.textAlignment=NSTextAlignmentCenter;
    bar1.text=[NSString stringWithFormat:@"%i",num];
    num++;
    
    bar1.backgroundColor=[self randomColor];
    
    NSInteger index=1;
    if(self.linearView.dataSource.count==0){
        index=0;
    }
    [self.linearView insertItem:bar1 margin:XHFMarginMake(5,5,5,5) atIndex:index withAnimation:UITableViewRowAnimationNone];
    
}

- (IBAction)deleteAction:(id)sender {
    if(self.linearView.items.count>0){
        UIView *item=[self.linearView.items objectAtIndex:0];
        [self.linearView removeItem:item withAnimation:UITableViewRowAnimationTop];
    }
}

- (IBAction)replaceAction:(id)sender {
    if(self.linearView.items.count==0){
        return;
    }
    UILabel *bar1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 50)];
    bar1.textAlignment=NSTextAlignmentCenter;
    bar1.text=[NSString stringWithFormat:@"Replace"];
    
    bar1.backgroundColor=[self randomColor];
    
    [self.linearView replaceItem:[self.linearView.items objectAtIndex:0] withNewItem:bar1 withAnimation:UITableViewRowAnimationFade];
}

- (IBAction)resizeAction:(id)sender {
    
    
    static int num=0;
    if(self.linearView.items.count>0){
        UILabel *label=[self.linearView.items objectAtIndex:0];
        label.text=[NSString stringWithFormat:@"Resize %i",num];
        CGRect bounds=label.frame;
        bounds.size.height=10+(arc4random() % 50);
        label.bounds=bounds;
        num++;
        [self.linearView needLayoutForItem:label];
    }
    
}

-(UIColor*)randomColor{
    float red=abs(arc4random()) %255 /255.0;
    float green=abs(arc4random()) %255 /255.0;
    float blue=abs(arc4random()) %255 /255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
@end
