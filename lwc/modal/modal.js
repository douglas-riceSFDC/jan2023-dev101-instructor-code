import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {
    @api title;
    @api buttonLabel;

    modalShown = false;

    @api
    toggleModal() {
        this.modalShown = !this.modalShown;
    }
}