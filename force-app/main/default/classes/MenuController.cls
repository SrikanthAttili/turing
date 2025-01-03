public with sharing class MenuController {
  static Integer pageSize = 6;

  @AuraEnabled(Cacheable=true scope='global')
  public static PagedResult getMenuRecords(Integer pageNumber) {
    String userLanguage = UserInfo.getLanguage();
    Integer offset = (pageNumber - 1) * (MenuController.pageSize);
    PagedResult result = new PagedResult();
    result.pageSize = pageSize; // 9 dhaka undochu
    result.pageNumber = pageNumber; // rendo page lo
    Integer totalItemCount = [
      SELECT COUNT()
      FROM Menu__c
      WITH SECURITY_ENFORCED
    ];
    result.totalItemCount = totalItemCount;
    List<Menu__c> menuRecords = new List<Menu__c>();
    for (Menu__c menuItem : [
      SELECT
        Id,
        Name,
        Price__c,
        Image__c,
        Short_Description__c,
        Custom_label_for_short_description__c,
        Custom_label_for_name__c
      FROM Menu__c
      WITH SECURITY_ENFORCED
      ORDER BY CreatedDate DESC
      LIMIT :MenuController.pageSize
      OFFSET :offset
    ]) {
      system.debug('$$$$$$ ' + menuItem.Custom_label_for_short_description__c);

      if (menuItem.Custom_label_for_short_description__c != null) {
        menuItem.Short_Description__c = getTranslatedValue(
          menuItem.Custom_label_for_short_description__c,
          userLanguage
        );
      }
      if (menuItem.Custom_label_for_name__c != null) {
        system.debug('$$$$$$ ' + menuItem.Custom_label_for_name__c);
        menuItem.Name = getTranslatedValue(
          menuItem.Custom_label_for_name__c,
          userLanguage
        );
      }
      menuRecords.add(menuItem);
    }
    result.records = menuRecords;
    system.debug('&&&&& ' + result);
    return result;
  }

  @AuraEnabled(Cacheable=true scope='global')
  public static string getTranslatedValue(
    String customLabelAPIName,
    String userLanguage
  ) {
    String translatedValue = '';
    if (Label.translationExists('', customLabelAPIName, userLanguage)) {
      translatedValue = Label.get('', customLabelAPIName, userLanguage);
    } else {
      translatedValue = Label.get('', customLabelAPIName);
    }
    return translatedValue;
  }
}
