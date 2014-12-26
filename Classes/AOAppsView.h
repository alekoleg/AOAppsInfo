//
//  AOAppsView.h
//  AOAppsIfo
//
//  Created by Alekseenko Oleg on 25.12.14.
//  Copyright (c) 2014 alekoleg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOAppsView : UIView

+ (instancetype)appsViewWithWidth:(CGFloat)widht;

@property (nonatomic, strong) NSString *noDataErrorText;
@property (nonatomic, readonly) UILabel *titleLabel;

@end
