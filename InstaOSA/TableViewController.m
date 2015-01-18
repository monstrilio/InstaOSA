//
//  TableViewController.m
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import "TableViewController.h"
#import "CustomInfiniteIndicator.h"
#import "UIScrollView+InfiniteScroll.h"
#import "DetailViewController.h"
#import "AFBlurSegue.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramService.h"
#import "NSDictionary+selfie_package.h"
#import "NSDictionary+Selfie.h"
#import "AJNotificationView.h"


#define kRowSize 120
#define kImageSize 96

@interface TableViewController()

@property (strong) NSMutableArray * resultArray;

@property (nonatomic) BOOL blur;
@property (nonatomic) int transitionStyle;

@end

@implementation TableViewController

@synthesize nextPage = _nextPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultArray = [[NSMutableArray alloc] init];
    _blur = YES;
    
    // enable auto-sizing cells on iOS 8
    if([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.estimatedRowHeight = kRowSize;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.nextPage = @"";
    __weak typeof(self) weakSelf = self;
    // Create custom indicator
    UIImage *image = [UIImage imageNamed:@"activity_indicator"];
    CustomInfiniteIndicator *indicator = [[CustomInfiniteIndicator alloc] initWithImage:image];
    // Set custom indicator
    [self.tableView setInfiniteIndicatorView:indicator];
    // Add infinite scroll handler
    [self.tableView addInfiniteScrollWithHandler:^(UIScrollView* scrollView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadPictures:^{
            // Finish infinite scroll animations
            [scrollView finishInfiniteScroll];
        }];
    }];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditTable)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    
    // Load first pictures
    [self loadPictures:nil];
}

#pragma mark - Get Data

- (void)loadPictures:(void(^)(void))completion
{
    InstagramService *service = [InstagramService sharedInstagramHTTPClient];
    service.delegate = self;
    [service loadPictures:self.nextPage completion:completion];
}

- (void)instagramService:(InstagramService *)service didUpdateWithPictures:(id)pictures completion:(void(^)(void))completion
{
    
    // Decode models on background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSArray* newPhotos = [NSArray new];
        
        newPhotos = [pictures arraySelfiesLow];
        
        // Append new data on main thread and reload table
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.nextPage = [pictures nextPage];
            [self.resultArray addObjectsFromArray:newPhotos];
            [self.tableView reloadData];
            
            self.navigationItem.rightBarButtonItem.enabled = self.resultArray.count != 0;
            if(completion) {
                completion();
            }
            
        });
    });
}

- (void)instagramService:(InstagramService *)service didFailWithError:(NSError *)error completion:(void(^)(void))completion
{
    if(completion) {
        completion();
    }
    
    [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                    type:AJNotificationTypeRed
                                   title:@"Unable to connect with server"
                         linedBackground:AJLinedBackgroundTypeDisabled
                               hideAfter:2.5f];
    self.navigationItem.rightBarButtonItem.enabled = self.resultArray.count != 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)EditTable
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowSize;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *images = self.resultArray;
    NSString *picSelfies = images[indexPath.row];
    NSURL *url = [NSURL URLWithString:picSelfies];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder.png"];
    
    //Retrieve image using AFNetworking Category
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:request placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
                                       if (image.size.width != kImageSize || image.size.height != kImageSize)
                                       {
                                           CGSize itemSize = CGSizeMake(kImageSize, kImageSize);
                                           UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                                           CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                           [image drawInRect:imageRect];
                                           weakCell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                                           UIGraphicsEndImageContext();
                                           
                                           
                                       }
                                       else
                                       {
                                           weakCell.imageView.image = image;
                                       }
                                       
                                       [weakCell setNeedsLayout];
    }failure:nil];

    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *urlImage = [self.resultArray objectAtIndex:indexPath.row];
    DetailViewController *controller = [segue destinationViewController];
    controller.urlImage = urlImage;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    if (self.editing && indexPath.row == ([self.resultArray count])) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.resultArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark Row reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *item = [self.resultArray objectAtIndex:fromIndexPath.row];
    [self.resultArray removeObject:item];
    [self.resultArray insertObject:item atIndex:toIndexPath.row];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == alertView.firstOtherButtonIndex) {
        [self loadPictures:nil];
    }
}

@end
