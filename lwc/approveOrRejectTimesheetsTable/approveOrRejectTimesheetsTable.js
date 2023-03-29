import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimesheetsTable extends LightningElement {
    @api timesheets;
    @api title;

    selectedRows = [];

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Hours', fieldName: 'Hours__c', type: 'number'},
        { label: 'Employee', fieldName: 'Employee__c'},
        { label: 'Status', fieldName: 'Status__c'},
    ];

    get noRowsSelected() {
        return this.selectedRows.length === 0;
    }

    handleSelectedRows(event) {
        let selectedRows = event.detail.selectedRows;
        console.log(JSON.parse(JSON.stringify(selectedRows)));

        this.selectedRows = selectedRows;
    }

    approveOrRejectTimesheets(event) {
        let status = event.currentTarget.dataset.status;

        this.dispatchEvent(new CustomEvent('approveorreject', {
            detail: {
                timesheets: this.selectedRows,
                status: status
            }
        }));

        this.toggleModal();
    }

    toggleModal() {
        this.selectedRows = [];
        this.template.querySelector('c-modal').toggleModal();
    }
}