//
//  UIView+Viewcontroll.m
//  UIResponder
//
//  Created by 周波 on 16/3/1.
//  Copyright © 2016年 周波. All rights reserved.
//

#import "UIView+Viewcontroll.h"

@implementation UIView (Viewcontroll)

- (UIViewController *)viewcontroller{
    
    //---取代下一个响应者
    UIResponder *next  = self.nextResponder;
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
            break;
        }
        //---去下一个响应者
        next = next.nextResponder;
    }while (next != nil);
    
    return nil;
}
@end
