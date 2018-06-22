//
//  lz_NavigationController.h
//  Pods-lz_WebViewController_Example
//
//  Created by Liyou on 2018/6/22.
//

#import <UIKit/UIKit.h>

@class lz_NavigationController;
@protocol lz_NavigationControllerShouldPopProtocol <NSObject>

- (BOOL)lz_NavigationControllerShouldPopItem:(lz_NavigationController *)navigationController;
@end

@interface lz_NavigationController : UINavigationController

@end
