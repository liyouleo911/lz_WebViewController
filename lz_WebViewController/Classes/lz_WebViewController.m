//
//  lz_WebViewController.m
//  Pods-lz_WebViewController_Example
//
//  Created by Liyou on 2018/6/22.
//

#import "lz_WebViewController.h"
#import "lz_NavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface lz_WebViewController()<WKNavigationDelegate, lz_NavigationControllerShouldPopProtocol>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy)   NSString *urlString;
@property (nonatomic, assign) BOOL cachePopGestureRecognizerSetting;

@end

@implementation lz_WebViewController

#pragma mark - public

-(instancetype)initWithUrlString:(NSString *)urlString {
    
    if (self = [super init]) {
        _urlString = urlString;
    }
    return self;
}

-(void)reloadWebView{
    
    [self.webView reload];
}

- (void)webViewLoadRequest {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:30];
    [self.webView loadRequest:request];
}

#pragma mark - life circle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.cachePopGestureRecognizerSetting = self.navigationController.interactivePopGestureRecognizer.isEnabled;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    [self.view addSubview:self.webView];
    [self webViewLoadRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - update nav items

-(void)updateNavigationItems {
    
    if (self.webView.canGoBack) {
        self.fd_interactivePopDisabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.closeButtonItem] animated:NO];
    }else{
        self.fd_interactivePopDisabled = NO;
        [self.navigationItem setLeftBarButtonItems:nil];
    }
}

#pragma mark - selectors

-(void)closeItemClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable returnValue, NSError * _Nullable error) {
        self.navigationItem.title = (NSString *)returnValue;
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self updateNavigationItems];
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable returnValue, NSError * _Nullable error) {
        self.navigationItem.title = (NSString *)returnValue;
    }];
}

#pragma mark - lz_NavigationControllerShouldPopProtocol

- (BOOL)lz_NavigationControllerShouldPopItem:(lz_NavigationController *)navigationController {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        [[self.navigationController.navigationBar subviews] lastObject].alpha = 1;
        return NO;
    }
    return YES;
}

#pragma mark - setters and getters

- (WKWebView*)webView {
    
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIBarButtonItem*)closeButtonItem {
    
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect frame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, 2.0);
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _progressView.tintColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        NSLog(@"%f", self.webView.estimatedProgress);
        [_progressView setAlpha:1.0f];
        [_progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        __weak typeof (self) weakSelf = self;
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [weakSelf.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [weakSelf.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
