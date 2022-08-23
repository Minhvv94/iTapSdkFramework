//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "NewsView.h"
#import "Utils.h"
#import "HMSegmentedControl.h"
#import "CellNewsView.h"
#import "CellLoadingMore.h"
#import "ListNewsJson.h"
#import "GameApiRequest.h"
#import "DetailNewsView.h"
#import "UIImageView+AFNetworking.h"
@implementation NewsView
{
    NSMutableArray* listPosts;
    NSInteger totalPost;
    NSInteger initPage;
    NSInteger sizeInPage;
    BOOL isLoadingData;
    BOOL noMoreData;
}
@synthesize tbNews;
-(void)configUI:(UIView *)parentView{
    [super configUI:parentView];
    NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
    UINib *cellNib = [UINib nibWithNibName:@"CellNewsView" bundle:myBundle];
    [tbNews registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    UINib *cellNibLoading = [UINib nibWithNibName:@"CellLoadingMore" bundle:myBundle];
    [tbNews registerNib:cellNibLoading forCellReuseIdentifier:@"CellLoadingMore"];
    
    tbNews.rowHeight = UITableViewAutomaticDimension;
    tbNews.estimatedRowHeight = 48;
    
    self->tbNews.dataSource = self;
    self->tbNews.delegate = self;
    
    [self loadData];
}
- (void)initInternals{
    [super initInternals];
    listPosts = [[NSMutableArray alloc] init];
    initPage = 1;
    sizeInPage = 10;
    isLoadingData = FALSE;
    noMoreData = FALSE;
}
-(void) loadData{
    if(noMoreData){
        return;
    }
    if(!isLoadingData){
        isLoadingData = TRUE;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
                NSDictionary* params = @{
                    @"page":[[NSNumber alloc] initWithInt:initPage],
                    request_app_package:appInfo.packageId,
                    @"size":[[NSNumber alloc] initWithInt:sizeInPage]
                };
                NSString* accessToken = [[Sdk sharedInstance] accessToken];
                [[GameApiRequest sharedInstance] callGetMethod:PATH_GAME_LIST_NEWS withParams:params withBody:nil withToken:accessToken completion:^(id  _Nullable result) {
                    [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                    ListNewsJson *resp = [[ListNewsJson alloc] initFromDictionary:result];
                    if(resp != NULL){
                        if(resp.statusCode == CODE_0){
                            if(resp.data.listPostInPage.count > 0){
                                [self->listPosts addObjectsFromArray:resp.data.listPostInPage];
                                self->initPage += 1;
                            }
                            else{
                                self->noMoreData = TRUE;
                            }
                            self->totalPost = resp.data.totalPost;
                            
                            [self.tbNews reloadData];
                            isLoadingData = FALSE;
                        }
                    }} error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
                        isLoadingData = FALSE;
                    }];
            });
        });
        
    }
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return listPosts.count;
    }
    else if (section == 1){
        return 1;
    }
    else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ListNews *itemData = [listPosts objectAtIndex:indexPath.row];
        UIViewController *topView = [Utils topViewController];
        DetailNewsView *customView =(DetailNewsView*) [Utils loadViewFromNibFile:[self class] universalWithNib:@"DetailNewsView"];
        customView.idNews = [NSString stringWithFormat: @"%ld", (long)itemData.newsId];
        customView.callback = ^(NSString* identifier) {
            NSLog(@"Hide %@",identifier );
        };
        customView.translatesAutoresizingMaskIntoConstraints = NO;
        customView.tag = 202;
        [topView.view addSubview:customView];
        [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 92;
    }
    else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Cell1Identifier = @"Cell";
    static NSString *Cell2Identifier = @"CellLoadingMore";
    
    UITableViewCell *cell = NULL;
    if(indexPath.section == 0){
        ListNews *itemData = [listPosts objectAtIndex:indexPath.row];
        cell = (CellNewsView *)[tableView dequeueReusableCellWithIdentifier:Cell1Identifier];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
        
        NSDictionary *attrs1 = @{ NSForegroundColorAttributeName : [Utils colorFromHexString:color_main_orange] };
        NSString *str1 = [NSString stringWithFormat:@"[%@]",itemData.categoryName];
        
        NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:str1 attributes:attrs1];
        
        NSDictionary *attrs2 = @{ NSForegroundColorAttributeName : UIColor.blackColor };
        
        NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",itemData.titleNews] attributes:attrs2];
        [attributedString appendAttributedString:attrStr1];
        [attributedString appendAttributedString:attrStr2];
        ((CellNewsView *)cell).titleNews.attributedText = attributedString;
        ((CellNewsView *)cell).publishedDate.text = [Utils getLocaleFormatDate:itemData.publishedAt];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"imgNewsSample"
                                               inBundle:[NSBundle bundleForClass:self.class]
                          compatibleWithTraitCollection:nil];
        
        [((CellNewsView *)cell).thumbNews setImageWithURL:itemData.thumbUrl
                                         placeholderImage:placeholderImage];
    }
    else{
        cell = (CellLoadingMore *)[tableView dequeueReusableCellWithIdentifier:Cell2Identifier];
        if(!noMoreData){
            [((CellLoadingMore *) cell).loadingMore startAnimating];
        }
        else{
            [((CellLoadingMore *) cell).loadingMore stopAnimating];
            [((CellLoadingMore *) cell).loadingMore setHidden:YES];
            ((CellLoadingMore *) cell).lbIndicator.text = [TSLanguageManager localizedString:@"Không có dữ liệu"];;
        }
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //offsetY là khung frame hiển thị so với vị trí đầu
    float offsetY = scrollView.contentOffset.y;
    //contentsize là kích thước của scrollview khi có full nội dụng
    //ví dụ table có 10 phần tử
    float contentHeight = scrollView.contentSize.height;
    //size hiển thị của frame, tức là vùng nhìn thấy
    float heightFrame = scrollView.frame.size.height;
    /*NSLog(@"offsetY: %f",offsetY);
    NSLog(@"contentHeight: %f",contentHeight);
    NSLog(@"heightFrame: %f",heightFrame);*/
    if ((offsetY > contentHeight - scrollView.frame.size.height- 10) && !isLoadingData) {
        [self loadData];
    }
}
@end
