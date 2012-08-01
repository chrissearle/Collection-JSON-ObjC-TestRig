//
//  ViewController.m
//  TestRig
//
//  Created by Chris Searle on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CJCollection.h"
#import "CJLink.h"
#import "CJItem.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize webView;
@synthesize textField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [textField setText:@"http://employee.herokuapp.com/"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (NSArray *) getLinks:(NSDictionary *) collection {
    return [collection objectForKey:@"links"];
}

- (NSString *) getDataAsString:(NSArray *) array {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result appendString:@"<table>"];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary *)obj;

        [dict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
            [result appendFormat:@"<tr><td>%@</td><td>%@</td></tr>", key, obj];
        }];
    }];
    [result appendString:@"</table>"];
    
    return [NSString stringWithString:result];
}

- (NSString *)getHtmlHeader {
    return @"<html>\n"
            "<head>\n"
            "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/>\n"
            "</head>\n"
            "<body>\n";
}

- (NSString *)getHtmlFooter {
    return @"\n</body>\n</html>\n";
}

- (NSString *)buildPage:(CJCollection *)collection {
    NSMutableString *html = [[NSMutableString alloc] init];
    
    [html appendString:[self getHtmlHeader]];
    
    [html appendFormat:@"<p><b><a href='%@'>%@</a></b></p>", collection.href, collection.href];
    [html appendFormat:@"<p>Version: %@", collection.version];
    
    [html appendString:@"<p><i>Items</i></p>"];
    [collection.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CJItem *item = (CJItem *)obj;
        
        [html appendFormat:@"<p><a href='%@'>%@</a></p>", item.href, item.href];
        
        [html appendString:[self getDataAsString:item.data]];
    }];
    [html appendString:@"</ul>"];
    
    [html appendString:@"<p><i>Links</i></p>"];
    [html appendString:@"<ul>"];
    [collection.links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CJLink *link = (CJLink *)obj;
        
        [html appendFormat:@"<li>%@: <a href='%@'>%@</a></li>", link.rel, link.href, link.prompt];
    }];
    [html appendString:@"</ul>"];
    
    [html appendString:[self getHtmlFooter]];

    return [NSString stringWithString:html];
}

- (void)fetchedData:(NSData *)responseData {
    CJCollection *collection = [CJCollection collectionForNSData:responseData];
    
    [textField setText:collection.href.absoluteString];

    [self.webView loadHTMLString:[self buildPage:collection] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)fetch:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (IBAction)click:(id)sender {
    [self fetch:[NSURL URLWithString: [textField text]]];
}

- (IBAction)reset:(id)sender {
    [textField setText:@"http://employee.herokuapp.com/"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"Request: %@", request);
    
    if ([[request URL] isFileURL]) {
        return YES;
    } else {
        [self fetch:[request URL]];
        return NO;
    }
}

@end
