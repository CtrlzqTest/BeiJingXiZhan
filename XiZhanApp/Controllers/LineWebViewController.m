//
//  LineWebViewController.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LineWebViewController.h"

@interface LineWebViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *_hud;
}
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation LineWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    
    // 返回按钮
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"back" selectImage:nil action:^(AYCButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didchangeUrl) name:UIWebViewNavigationTypeLinkClicked object:nil];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = [request.URL absoluteString];
//    NSString *webStr = [webView.request.URL absoluteString];
    if ([urlStr isEqualToString:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxee03c0d9fd45289e&redirect_uri=http://alweixin.bjbus.com/oauth2.php?url=http%3a%2f%2fwww.bjbus.com%2fRTBus%2fapp%2fc.html%3fop%3dg&response_type=code&scope=snsapi_base&state=123&wid=1&connect_redirect=1#wechat_redirect"]) {
        [webView stopLoading];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bjbus.com/RTBus/app/c.html?op=g&openid=1"]]];
    }
    if ([urlStr isEqualToString:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxee03c0d9fd45289e&redirect_uri=http://alweixin.bjbus.com/oauth2.php?url=http%3a%2f%2fwww.bjbus.com%2fRTBus%2fapp%2fc.html%3fop%3dx&response_type=code&scope=snsapi_base&state=123&wid=1&connect_redirect=1#wechat_redirect"]) {
        [webView stopLoading];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bjbus.com/RTBus/app/c.html?op=x&openid=oBwutjrbTpDQOs3PagOpRPFPNpRk"]]];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hud hide:YES];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [_hud hide:YES];
    [MBProgressHUD showError:@"网络不给力！" toView:nil];
}

- (void)didchangeUrl {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
