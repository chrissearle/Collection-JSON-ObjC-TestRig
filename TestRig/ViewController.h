//
//  ViewController.h
//  TestRig
//
//  Created by Chris Searle on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)click:(id)sender;

@end
