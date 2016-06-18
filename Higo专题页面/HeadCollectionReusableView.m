//
//  HeadCollectionReusableView.m
//  Higo专题页面
//
//  Created by 宓珂璟 on 16/6/17.
//  Copyright © 2016年 宓珂璟. All rights reserved.
//

#import "HeadCollectionReusableView.h"
#import "ContryProductCollectionViewCell.h"
#import "HigoModel.h"
#import <UIImageView+WebCache.h>

@interface HeadCollectionReusableView () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

static NSString *identyfy = @"SecondCollectionViewCell";
@implementation HeadCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headCollection.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.headCollection.delegate = self;
    self.headCollection.dataSource = self;
    [self.headCollection registerNib:[UINib nibWithNibName:identyfy bundle:nil] forCellWithReuseIdentifier:identyfy];
}

#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.headImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContryProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identyfy forIndexPath:indexPath];
    [self configure:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configure:(ContryProductCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(cell)weakCell = cell;
    
    CategoryModel *goods = self.headImages[indexPath.item];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:goods.image.image_original] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.headImageView.alpha = 0;
            [UIView animateWithDuration:1.0 animations:^{
                
                weakCell.headImageView.alpha = 1.0f;
            }];
        }
        else
        {
            weakCell.headImageView.alpha = 1.0f;
        }
    }];
    
    cell.headLabel.text = goods.name;
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}


@end
