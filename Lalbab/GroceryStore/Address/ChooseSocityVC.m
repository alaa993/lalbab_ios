//
//  ChooseSocityVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ChooseSocityVC.h"
#import "LocalityCell.h"
#import "Languge.h"
#import "Common.h"

@interface ChooseSocityVC ()
{
    NSMutableArray *searchResults;
    BOOL issearching;
}
@end

@implementation ChooseSocityVC
@synthesize dataArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedStrings(@"Choose Socity", nil);
    issearching = false;
    // Do any additional setup after loading the view.
   
    [self getLocality];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getLocality{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;
    if(_pincode != nil){
        [params setObject:_pincode forKey:@"pincode"];
    }
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_SOCITY] withParams:params progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        
            dataArray = [[NSMutableArray alloc] initWithArray:responseObject];
            [tableview reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = nil;
    
    simpleTableIdentifier=@"LocalityCell";
    
    
    LocalityCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    
    NSMutableDictionary *dictdoct;
    if (issearching) {
        dictdoct = [searchResults objectAtIndex:indexPath.row];
    }else {
        dictdoct = [dataArray objectAtIndex:indexPath.row];
    }
    cell.lblTitle.text = [NSString stringWithFormat:@"%@, %@",[dictdoct valueForKey:@"socity_name"],[dictdoct valueForKey:@"pincode"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (issearching) {
        if (searchResults!=nil) {
            return searchResults.count;
        }
    }else{
        if (dataArray!=nil) {
            return dataArray.count;
        }
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (issearching) {
        [[NSUserDefaults standardUserDefaults] setObject:[searchResults objectAtIndex:indexPath.row] forKey:@"selected_socity"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[dataArray objectAtIndex:indexPath.row] forKey:@"selected_socity"];
    }
    [self.navigationController popViewControllerAnimated:true];
}


//search button was tapped
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContentForSearchText:searchBar.text ];
    [mySearchBar setShowsCancelButton:NO animated:YES];
}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self filterContentForSearchText:searchBar.text ];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //if(![searchText isEqualToString:@""])
    [self filterContentForSearchText:searchBar.text ];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(![searchBar.text isEqualToString:@""])
        [self filterContentForSearchText:searchBar.text ];
    
    [mySearchBar setShowsCancelButton:YES animated:YES];
}
- (void)filterContentForSearchText:(NSString*)searchText
{
    if([searchText isEqualToString:@""]){
        issearching = false;
    }else{
        issearching = true;
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"socity_name contains[c] %@", searchText];
        NSPredicate *resultPredicate2 = [NSPredicate predicateWithFormat:@"pincode contains[c] %@", searchText];
        NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[resultPredicate, resultPredicate2]];
        searchResults = [[NSMutableArray alloc] initWithArray:[dataArray filteredArrayUsingPredicate:predicate]];
    }
    [tableview reloadData];
}
//user tapped on the cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    issearching = false;
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
    [mySearchBar setShowsCancelButton:NO animated:YES];
}
@end
