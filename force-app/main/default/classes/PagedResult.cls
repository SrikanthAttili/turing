public with sharing class PagedResult {
  @AuraEnabled
  public Integer pageSize { get; set; }

  @AuraEnabled
  public Integer pageNumber { get; set; }

  @AuraEnabled
  public Integer totalItemCount { get; set; }

  @AuraEnabled
  public List<Menu__c> records { get; set; }
}
