//
//  lz_WebViewController.h
//  Pods-lz_WebViewController_Example
//
//  Created by Liyou on 2018/6/22.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface lz_WebViewController : UIViewController

- (instancetype)initWithUrlString:(NSString *)urlString;
- (void)reloadWebView;
- (void)webViewLoadRequest;
@end
