//
//  ViewController.h
//  TestRig
//
//  Created by Chris Searle on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

- (IBAction)click:(id)sender;
- (IBAction)reset:(id)sender;

@end
