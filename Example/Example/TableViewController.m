//
//  TableViewController.m
//  Example
//
//  Created by Mingenesis on 7/1/16.
//
//

#import "TableViewController.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation TableViewController

- (void)loadView {
    [super loadView];
    
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *data = [NSMutableArray array];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateStyle = kCFDateFormatterFullStyle;
    dateFormater.timeStyle = kCFDateFormatterMediumStyle;
    
    for (NSInteger idx = 0; idx < 50; idx ++) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:idx * 9999999];
        [data addObject:[dateFormater stringFromDate:date]];
    }
    
    self.data = data;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

@end
