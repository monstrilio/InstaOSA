//
//  TableViewController.h
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramService.h"

@interface TableViewController : UITableViewController <UIAlertViewDelegate, InstagramHTTPClientDelegate>

@property (copy) NSString *nextPage;

@end
