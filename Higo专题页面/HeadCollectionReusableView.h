//
//  HeadCollectionReusableView.h
//  Higo专题页面
//
//  Created by 宓珂璟 on 16/6/17.
//  Copyright © 2016年 宓珂璟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UICollectionView *headCollection;
@property (nonatomic,strong) NSMutableArray *headImages;
@end
