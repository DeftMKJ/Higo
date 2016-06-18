//
//  ContryProductCollectionViewCell.h
//  Taowaitao
//
//  Created by 宓珂璟 on 16/6/8.
//  Copyright © 2016年 walatao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContryProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIView *headMaskView;
@end


