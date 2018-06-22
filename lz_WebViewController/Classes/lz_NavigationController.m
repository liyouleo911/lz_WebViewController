//
//  lz_NavigationController.m
//  Pods-lz_WebViewController_Example
//
//  Created by Liyou on 2018/6/22.
//

#import "lz_NavigationController.h"

@interface UINavigationController (UINavigationControllerShouldPopItem)

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincomplete-implementation"
@implementation UINavigationController (UINavigationControllerShouldPopItem)
@end
#pragma clang diagnostic pop

@interface lz_NavigationController ()<UINavigationBarDelegate>

@end

@implementation lz_NavigationController

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    
    UIViewController *vc = self.topViewController;
    if (item != vc.navigationItem) {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
    
    if ([vc conformsToProtocol:@protocol(lz_NavigationControllerShouldPopProtocol)]) {
        if ([(id<lz_NavigationControllerShouldPopProtocol>)vc lz_NavigationControllerShouldPopItem:self]) {
            return [super navigationBar:navigationBar shouldPopItem:item];
        } else {
            return NO;
        }
    } else {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
}

@end
