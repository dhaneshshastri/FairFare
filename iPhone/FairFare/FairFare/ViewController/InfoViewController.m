//
//  InfoViewController.m
//  FairFare
//
//  Created by dhaneshs on 4/21/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
{
    NSURL* _url;
    __weak IBOutlet UIWebView *_webView;
}

@end

@implementation InfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _webView.delegate = self;
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    
    UIButton *_closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_closeButton];
    [_closeButton addTarget:self
                     action:@selector(stopJourney:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [_closeButton setTitle:@"X"
                  forState:UIControlStateNormal];
    
    [_closeButton setBackgroundColor:[UIColor colorWithRed:1.0
                                                     green:1.0
                                                      blue:1.0
                                                     alpha:0.5]];
    
    [_closeButton setContentCompressionResistancePriority:500
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    
    
    [_closeButton.layer setCornerRadius:15.0];
    
    [[LayoutManager layoutManager] alignView:_closeButton
                                   toRefView:self.view
                                  withOffset:CGPointZero
                                      inView:self.view
                         withAlignmentOption:NSLayoutAttributeRight
                       andRefAlignmentOption:NSLayoutAttributeRight];
    
    [[LayoutManager layoutManager] alignView:_closeButton
                                   toRefView:self.view
                                  withOffset:CGPointMake(65, 0)
                                      inView:self.view
                         withAlignmentOption:NSLayoutAttributeTop
                       andRefAlignmentOption:NSLayoutAttributeTop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUrl:(NSString*)url
{
    _url = nil;
    _url = [NSURL URLWithString:url];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page is loading");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished loading");
    

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
