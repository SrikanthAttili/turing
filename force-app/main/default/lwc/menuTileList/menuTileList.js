import { LightningElement, wire } from "lwc";
import getMenuRecords from "@salesforce/apex/MenuController.getMenuRecords";
export default class MenuTileList extends LightningElement {
  pageNumber = 1;
  pageSize;
  totalItemCount = 0;

  @wire(getMenuRecords, { pageNumber: "$pageNumber" })
  menu;

  handlePreviousPage() {
    this.pageNumber = this.pageNumber - 1;
  }

  handleNextPage() {
    this.pageNumber = this.pageNumber + 1;
  }
}
