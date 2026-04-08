export enum QuoteCategory {
  MOTIVATION = 'motivation',
  WISDOM = 'wisdom',
  LIFE = 'life',
  SUCCESS = 'success',
  COURAGE = 'courage'
}

export class DailyQuoteModel {
  public id:number;
  public bodyText: string;
  public author: string;
  public isFavourite: boolean = false;
  public category: QuoteCategory = QuoteCategory.MOTIVATION;

  constructor(id:number, bodyText: string, author: string, category?: QuoteCategory) {
    this.id = id;
    this.bodyText = bodyText;
    this.author = author;
    this.category = category || QuoteCategory.MOTIVATION;
  }
}