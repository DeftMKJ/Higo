//
//  ContryProductCollectionViewCell.m
//  Taowaitao
//
//  Created by 宓珂璟 on 16/6/8.
//  Copyright © 2016年 walatao.com. All rights reserved.
//

#import "ContryProductCollectionViewCell.h"

@implementation ContryProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = 10;
    self.headImageView.clipsToBounds = YES;
    self.headMaskView.layer.cornerRadius = 10;
    self.headMaskView.clipsToBounds = YES;
    self.headMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

@end
