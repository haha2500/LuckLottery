//
//  QCBuyViewController.h
//  LuckLottery
//
//  Created by Sun Wu on 13-8-6.
//
//

#import <UIKit/UIKit.h>

@interface QCBuyViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiForward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiStop;
- (IBAction)onGoBack:(id)sender;
- (IBAction)onGoForward:(id)sender;
- (IBAction)onRefresh:(id)sender;
- (IBAction)onStop:(id)sender;
@end
