export class DailyQuoteModel {
  public id:number;
  public bodyText: string;
  public author: string;
  public isFavourite: boolean = false;

  constructor(id:number, bodyText: string, author: string) {
    this.id = id;
    this.bodyText = bodyText;
    this.author = author;
  }
}