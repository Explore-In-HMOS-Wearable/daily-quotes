import { DailyQuoteModel } from '../model/DailyQuoteModel';

@Observed
export class DailyQuoteViewModel {
  static instance = new DailyQuoteViewModel();

  getQuoteList(): Array<DailyQuoteModel> {
    return DAILY_QUOTE_DATA;
  }

  getDailyQuote(): Array<DailyQuoteModel> {
    let today = new Date();
    let dayIndex = today.getDay();
    return [DAILY_QUOTE_DATA[dayIndex]]
  }

  getFavouriteQuotes(favouriteQuoteIDs: Array<number>): Array<DailyQuoteModel> {
    return DAILY_QUOTE_DATA.filter((quote) => favouriteQuoteIDs.indexOf(quote.id) !== -1);
  }
}

const DAILY_QUOTE_DATA: Array<DailyQuoteModel> = [
  new DailyQuoteModel(
    1,
    `If you can dream it, you can do it`,
    `Walt Disney`,
  ),
  new DailyQuoteModel(
    2,
    `The journey of a thousand miles begins with one step`,
    `Lao Tzu`,
  ),
  new DailyQuoteModel(
    3,
    `The road to success and the road to failure are almost exactly the same`,
    `Colin R. Davis`
  ),
  new DailyQuoteModel(
    4,
    `Don’t let yesterday take up too much of today`,
    `Will Rogers`,
  ),
  new DailyQuoteModel(
    5,
    `He who conquers himself is the mightiest warrior`,
    `Confucius`,
  ),
  new DailyQuoteModel(
    6,
    `The only thing necessary for the triumph of evil is for good men to do nothing`,
    `Edmund Burke`,
  ),
  new DailyQuoteModel(
    7,
    `I have not failed. I've just found 10,000 ways that won't work`,
    `Thomas A. Edison`,
  )
];