//
//  ETubeCustomCell.m
//  EasyTube
//
//  Created by Sourabh Shekhar Singh on 20/11/12.
//  Copyright (c) 2012 XCS Technologies. All rights reserved.
//

#import "ETubeCustomCell.h"

@implementation ETubeCustomCell

@synthesize imageAtCell,titleAtCell,lengthAtCell,authorAtCell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
