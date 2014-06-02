//
//  FavoriteSnapTableViewCell.m
//  UTASnap
//
//  Created by James Fielder on 5/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "FavoriteSnapTableViewCell.h"

@implementation FavoriteSnapTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
