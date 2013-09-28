XHFLinearView
=============

iOS LinearView Container and  operate with animations


##Usage Example

```objective-c
    XHFLinearView *linearView=[[XHFLinearView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:linearView];
    //init linear view content views
    [linearView.dataSource addObject:XHFLinearViewUnitMake(someView, XHFMarginMake(0, 0, 0, 0))];
    //force layout linear view
    [linearView needLayout];
    //insert a view with animation
    [linearView insertItem:someView margin:XHFMarginMake(0, 0, 0, 0) atIndex:0 withAnimation:UITableViewRowAnimationFade];
    //replace a view with animation
    [linearView replaceItem:someView withNewItem:newView withAnimation:UITableViewRowAnimationFade];
    //resize a view with animation
    someView.frame=xxx;
    [linearView needLayoutForItem:someView];
    //remove a view with animation
    [linearView removeItemByIndex:0 withAnimation:UITableViewRowAnimationFade];
    
```
Checkout the demo project for additional tests and examples.

##Setup Instructions

1.add `src/XHFLinearView.h` and `src/XHFLinearView.m` to your project
