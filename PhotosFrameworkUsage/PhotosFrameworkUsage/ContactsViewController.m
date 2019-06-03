//
//  ContactsViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/30.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "ContactsViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ContactsViewController () <CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource>
- (IBAction)contactsOnClick;
- (IBAction)contactsTwoOnClick;
- (IBAction)editContactInfoOnClick;
- (IBAction)getContactInfoOnClick;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CNContact *contact;
@property (nonatomic, strong) NSArray<CNContact *> *contactsInfoArr;
@end

@implementation ContactsViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactsInfoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contactCellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CNContact *c = self.contactsInfoArr[indexPath.row];
    cell.textLabel.text = [c.familyName stringByAppendingString:c.givenName];
    cell.detailTextLabel.text = [c.phoneNumbers firstObject].value.stringValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CNContact *c = self.contactsInfoArr[indexPath.row];
    NSString *telphone = [@"tel:" stringByAppendingString:[c.phoneNumbers firstObject].value.stringValue];
    NSURL *telUrl = [NSURL URLWithString:telphone];
    if ([[UIApplication sharedApplication] canOpenURL:telUrl]) {
        [[UIApplication sharedApplication] openURL:telUrl];
    } else {
        [BaseViewController alertWithTitle:@"手机号错误"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 检索联系人
    if (status == CNAuthorizationStatusAuthorized) {
        [[[UIAlertView alloc] initWithTitle:@"已经有访问通讯录权限!" message:@"已经有访问通讯录权限!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    } else if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"获取访问相册权限!" message:@"获取访问相册权限!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    } else if (status == CNAuthorizationStatusNotDetermined) {
        [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted && error == nil) {
                    [[[UIAlertView alloc] initWithTitle:@"获取访问相册权限, 但有限制的访问!" message:@"获取访问相册权限, 但有限制的访问!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"获取访问相册权限失败!" message:[NSString stringWithFormat:@"请获取访问相册权限失败: because: %@!", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            });
        }];
    }
}

// 添加通讯录联系人信息
- (void)addContactInfo {
    // 初始化方法
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.namePrefix = @"Zhang";
    contact.nameSuffix = @"Jay";
    
    CNPhoneNumber *homePhoneNumber = [CNPhoneNumber phoneNumberWithStringValue:@"+8612345678901"];
    CNLabeledValue *labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:homePhoneNumber];
    contact.phoneNumbers = @[labeledValue];
    contact.emailAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelEmailiCloud value:@"123456@163.com"]];
    
    // CNContactStore是一个用于存取联系人的上下文桥梁
    CNContactStore *store = [[CNContactStore alloc] init];
    // 添加联系人
    [saveRequest addContact:contact toContainerWithIdentifier:[store defaultContainerIdentifier]];
    NSError *error = nil;
    // 只有执行此操作才会在通讯录生成记录
    BOOL flag = [store executeSaveRequest:saveRequest error:&error];
    if (flag && error == nil) {
        NSLog(@"save successful.");
        [[[UIAlertView alloc] initWithTitle:@"contact info save successful." message:@"contact info save successful." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"contact info save failure." message:[NSString stringWithFormat:@"contact info save failure, because : %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

// 获取通讯录联系人信息
- (void)requestContactsInfo {
    CNContactStore *store = [[CNContactStore alloc] init];
    // 检索条件，检索所有名字中有zhang的联系人
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"张"];
    predicate = [CNContact predicateForContactsInContainerWithIdentifier:[store defaultContainerIdentifier]];
    // 提取数据
    NSError *error = nil;
    NSArray<CNContact *> *contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactOrganizationNameKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey] error:&error];
//    for (CNContact *c in contacts) {
//        NSLog(@"%@", c);
//    }
    
//    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey,CNContactPhoneNumbersKey]];
//    [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//        NSLog(@"%@", contact);
//    }];
    
    self.contactsInfoArr = contacts;
    [self.tableView reloadData];
}

- (IBAction)contactsOnClick {
    // 只有使用present方式，CNContactPickerViewController才能正常显示，不能使用push方式打开
    CNContactPickerViewController *cpVc = [[CNContactPickerViewController alloc] init];
    cpVc.delegate = self;
    [self presentViewController:cpVc animated:YES completion:nil];
}

- (IBAction)contactsTwoOnClick {
    // 只有使用push方式，CNContactViewController才能正常显示，不能使用present方式打开，只有CNContactPickerViewController的CNContact才行
    CNContactViewController *contactVc = [CNContactViewController viewControllerForContact:self.contact];
    [self.navigationController pushViewController:contactVc animated:YES];
}

- (IBAction)editContactInfoOnClick {
    [self addContactInfo];
}

- (IBAction)getContactInfoOnClick {
    [self requestContactsInfo];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    NSLog(@"%@", picker);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSLog(@"%@", contact);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    NSLog(@"%@", contactProperty);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts {
    for (CNContact *contact in contacts) {
        NSLog(@"%@", contact);
    }
    
    self.contact = [contacts firstObject];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties {
    for (CNContactProperty *contactProperty in contactProperties) {
        NSLog(@"%@", contactProperty);
    }
}

@end
