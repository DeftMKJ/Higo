//
//  CountrySessionViewController.m
//  Taowaitao
//
//  Created by 宓珂璟 on 16/6/8.
//  Copyright © 2016年 walatao.com. All rights reserved.
//

#import "CountrySessionViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ContryProductCollectionViewCell.h"
#import <MJRefresh.h>
#import <GSKStretchyHeaderView.h>
#import "NSString+CP.h"
#import "GSKGeometry.h"
#import "GSKNibStretchyHeaderView.h"
#import "MKJAFNetWorkHelp.h"
#import "HigoModel.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import <UIImageView+WebCache.h>
#import "HeadCollectionReusableView.h"
#import "JZNavigationExtension.h"
#import "UINavigationController+StatusBarStyle.h"

@interface CountrySessionViewController () <UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIScrollViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic)  IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *productDataSource;
@property (nonatomic,strong) NSMutableArray *headImages;
@property (nonatomic,copy)   NSString *firstImageURL;
@property (nonatomic,assign) NSInteger currentPage;


@property (nonatomic,assign) BOOL isRefreshedData;
@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic)CGFloat headerViewHeight;
@property (nonatomic)UIImage * backItemImage1;//白
@property (nonatomic)UIImage * backItemHightLightImage1;//白
@property (nonatomic)UIImage * backItemImage2;//黑
@property (nonatomic)UIImage * backItemHightLightImage2;//黑
@property (nonatomic) CGFloat titleViewAlpha;
@property (nonatomic)UIButton * backButton;

@property (strong, nonatomic) IBOutlet GSKStretchyHeaderView *GSKHeadView;
@property (nonatomic,strong) GSKNibStretchyHeaderView *GSKHeadView1;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *productNumberName;

@property (weak, nonatomic) IBOutlet CHTCollectionViewWaterfallLayout *CHTLayout;
@property (nonatomic,weak) UIActivityIndicatorView *indicator;

@end

static NSString *identyfy = @"ContryProductCollectionViewCell";
static NSString *identyfy1 = @"FirstCollectionViewCell";
static NSString *reusehead  = @"HeadCollectionReusableView";
@implementation CountrySessionViewController

#pragma mark - 初始化模型对象  高度  bar的初始为白色
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 这个头时刻准备着
        self.headerViewHeight = 150;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    return self;
}


#pragma mark - [self setNeedsStatusBarAppearanceUpdate]给这个方法就能回调到这里
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.isRefreshedData == YES)
    {
        return self.statusBarStyle;
    }
    else
    {
        return UIStatusBarStyleDefault;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.jz_fullScreenInteractivePopGestureEnabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
    
    // 隐藏
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.navigationItem.titleView.alpha = self.titleViewAlpha;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 修改Plist，然后直接显示调用就会更改掉
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // 整个Section内嵌的距离上左下右
    self.CHTLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // sectionHeader高度
    self.CHTLayout.headerHeight = 80;
    // sectionFooterHeight
//    self.CHTLayout.footerHeight = 10;
    // 间距
    self.CHTLayout.minimumColumnSpacing = 10;
    self.CHTLayout.minimumInteritemSpacing = 10;
    self.CHTLayout.minimumContentHeight = 220;
    // 多少列
    self.CHTLayout.columnCount = 2;
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:identyfy bundle:nil] forCellWithReuseIdentifier:identyfy];
    [self.collectionView registerNib:[UINib nibWithNibName:identyfy1 bundle:nil]forCellWithReuseIdentifier:identyfy1];
    [self.collectionView registerNib:[UINib nibWithNibName:reusehead bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:reusehead];
    [self initBackButton];
    [self configGSKHeader];
    [self requestData];
    
}


// 上拉加载更多
- (void)loadMoreData
{
    __weak typeof(self)weakSelf = self;
    [[MKJAFNetWorkHelp shareRequest] MKJGETRequest:@"http://v.lehe.com/goods_category/get_goods" page:self.currentPage parameters:nil succeed:^(NSError *err, id obj) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        HigoList *list = (HigoList *)obj;
        NSMutableArray *indexpaths = [[NSMutableArray alloc] init];
        NSInteger index = [weakSelf.collectionView numberOfItemsInSection:0];
        self.currentPage ++;
        for (GoodsModel *model in list.goods_list) {
            [weakSelf.productDataSource addObject:model];
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
            index++;
            [indexpaths addObject:indexpath];
        }
        [weakSelf.collectionView insertItemsAtIndexPaths:indexpaths];
        
        
        
    } failure:^(NSError *err, id obj) {
        
        // error
    }];
    
}

-(void)initBackButton
{
    CGFloat offset = -14;
    //    if (IS_IPHONE6PLUS)
    //    {
    //        offset = -17;
    //    }
    self.backItemImage1 = [UIImage imageNamed:@"backItemImageWhite"];
    self.backItemHightLightImage1 = [UIImage imageNamed:@"backItemImageWhite"];
    self.backItemImage2 = [UIImage imageNamed:@"backItemImage"];
    self.backItemHightLightImage2 = [UIImage imageNamed:@"backItemImage_hl"];
    
    UIButton* backButton = [[UIButton alloc] init];
    [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [backButton setImage:self.backItemImage1 forState:UIControlStateNormal];
    [backButton setImage:self.backItemHightLightImage1 forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.backButton =  backButton;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIActivityIndicatorView *activiyy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activiyy.frame = CGRectMake(150, 300, 60, 60);
    [activiyy startAnimating];
    [self.view addSubview:activiyy];
    self.indicator = activiyy;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    self.collectionView.mj_footer = footer;
    
}
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

// GSK加载头部放大视图
- (void)configGSKHeader
{
    self.isRefreshedData = YES;
    // 需要不同效果请看源码，这里用IB加载的话就是能加载出Demo效果
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"GSKNibStretchyHeaderView"
                                                      owner:self
                                                    options:nil];
    self.GSKHeadView1 = nibViews.firstObject;
    self.GSKHeadView1.gskMaskView.alpha = 0.3;
    self.GSKHeadView1.maximumContentHeight = self.headerViewHeight;
}


- (void)requestData
{
    self.isRefreshedData = YES;
    self.currentPage = 0;
    [[MKJAFNetWorkHelp shareRequest] MKJGETRequest:@"http://v.lehe.com/goods_category/get_goods" page:self.currentPage parameters:nil succeed:^(NSError *err, id obj) {
        
        HigoList *list = (HigoList *)obj;
        self.productDataSource = list.goods_list;
        self.firstImageURL = list.banner.banner_pic.image_original;
        self.headImages = list.category_list;
        self.currentPage ++;
        [self.indicator removeFromSuperview];
        [self.collectionView addSubview:self.GSKHeadView1];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *err, id obj) {
        
        // error
    }];
    
}



#pragma mark - scrollView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",y);
    if (y >-self.headerViewHeight+1)
    {
        CGFloat deleta = self.headerViewHeight - 64;
        CGFloat alpha = (self.headerViewHeight+y)/deleta;
        self.jz_navigationBarBackgroundAlpha = alpha;
        
        if (alpha>0.6)
        {
            [self.backButton setImage:self.backItemImage2 forState:UIControlStateNormal];
            [self.backButton setImage:self.backItemHightLightImage2 forState:UIControlStateHighlighted];
             self.statusBarStyle = UIStatusBarStyleDefault;
            self.navigationItem.titleView.alpha = alpha;
            self.titleViewAlpha = self.navigationItem.titleView.alpha;
            self.title = @"😄😄😄";
        }
        else
        {
            self.statusBarStyle = UIStatusBarStyleLightContent;
            self.navigationItem.titleView.alpha = 0;
            self.titleViewAlpha = 0;
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        self.title = @"";
        self.navigationItem.titleView.alpha = 0;
        self.titleViewAlpha = 0;
        self.jz_navigationBarBackgroundAlpha = 0;
        [self.backButton setImage:self.backItemImage1 forState:UIControlStateNormal];
        [self.backButton setImage:self.backItemHightLightImage1 forState:UIControlStateHighlighted];
        self.statusBarStyle = UIStatusBarStyleLightContent;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productDataSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = nil;
    if (indexPath.item == 0) {
        ID = identyfy1;
    }
    else
    {
        ID = identyfy;
    }
    
    ContryProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [self configure:cell atIndexPath:indexPath];
    return cell;
}

- (void)configure:(ContryProductCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(cell)weakCell = cell;
    if (indexPath.item == 0)
    {
        [cell.firstImageView sd_setImageWithURL:[NSURL URLWithString:self.firstImageURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
            if (image && cacheType == SDImageCacheTypeNone) {
                weakCell.firstImageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                
                    weakCell.firstImageView.alpha = 1.0f;
                }];
            }
            else
            {
                weakCell.firstImageView.alpha = 1.0f;
            }
        }];
    }
    else
    {
        GoodsModel *goods = self.productDataSource[indexPath.item - 1];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:goods.main_image.image_original] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone) {
                weakCell.imageView.alpha = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    
                    weakCell.imageView.alpha = 1.0f;
                }];
            }
            else
            {
                weakCell.imageView.alpha = 1.0f;
            }
        }];
        if (![NSString isEmptyString:goods.goods_name]) {
            cell.nameLabel.text = goods.goods_name;
        }
        if (![NSString isEmptyString:goods.goods_display_list_price]) {
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",goods.goods_display_list_price];
        }
        if (!goods.group_info) {
            cell.countryLabel.text = [NSString stringWithFormat:@"%@ %@",goods.group_info.country,goods.group_info.city];
        }
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        return CGSizeMake(1,0.6);
    }
    if (self.CHTLayout.columnCount == 2) {
        return CGSizeMake(1,1.4);
    }
    else if (self.CHTLayout.columnCount == 3)
    {
        if (indexPath.item % 3 == 1) {
            return CGSizeMake(1, 1.8);
        }
        else
        {
            return CGSizeMake(1, 1.7);
        }
        
    }
    else
    {
        return CGSizeMake(1, 2);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        HeadCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusehead forIndexPath:indexPath];
        // 数组穿进去
        header.headImages = self.headImages;
        // 刷新里面的CollectionView控件
        [header.headCollection reloadData];
        return header;
    }
    return nil;
}



- (NSMutableArray *)productDataSource
{
    if (_productDataSource == nil) {
        _productDataSource = [[NSMutableArray alloc] init];
    }
    return _productDataSource;
}

@end
