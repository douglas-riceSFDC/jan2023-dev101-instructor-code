import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTimesheetsByProject from '@salesforce/apex/ApproveOrRejectTimesheetsController.getTimesheetsByProject';
import approveOrRejectTimesheets from '@salesforce/apex/ApproveOrRejectTimesheetsController.approveOrRejectTimesheets';
import LightningConfirm from 'lightning/confirm';

export default class ApproveOrRejectTimesheetsContainer extends LightningElement {
    @api recordId;
    @api title;

    timesheets;
    wiredTimesheetResponse;

    pageNumber = 0;

    get page0() {
        return pageNumber === 0;
    }

    get page1() {
        return pageNumber === 1;
    }

    @wire(getTimesheetsByProject, { projectId: '$recordId'})
    wiredTimesheets(response) {
        this.wiredTimesheetResponse = response;

        this.timesheets = response.data;
        if(response.error) {
            console.warn(error);
        }
    }

    async handleConfirmClick() {
        const result = await LightningConfirm.open({
            message: 'this is the prompt message',
            // variant: 'headerless',
            label: 'this is the aria-label value',
            theme: 'info'
            // setting theme would have no effect
        });
        console.log(result);
    }

    handleApproveOrRejectTimesheets(event) {
        let timesheetWrapper = {
            Timesheets: event.detail.timesheets,
            Status: event.detail.status
        };

        approveOrRejectTimesheets({ wrapper: timesheetWrapper })
            .then(response => {
                refreshApex(this.wiredTimesheetResponse);

                this.handleConfirmClick();

                console.log(`timesheets successfully ${event.detail.status.toLowerCase()}`);

                this.showToast('Timesheet Update', `Timesheets successfully ${event.detail.status.toLowerCase()}.`);
            })
            .catch(error => {
                console.warn(error);

                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant || 'success'
        }));
    }

}