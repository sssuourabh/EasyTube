//
//  ETubeCustomCell.h
//  EasyTube
//
//  Created by Sourabh Shekhar Singh on 20/11/12.
//  Copyright (c) 2012 XCS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETubeCustomCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageAtCell;


@property (strong, nonatomic) IBOutlet UILabel *titleAtCell;

@property (strong, nonatomic) IBOutlet UILabel *lengthAtCell;

@property (strong, nonatomic) IBOutlet UILabel *authorAtCell;



@end
