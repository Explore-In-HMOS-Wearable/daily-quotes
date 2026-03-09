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
  ),
  new DailyQuoteModel(
    8,
    `It does not matter how slowly you go as long as you do not stop`,
    `Confucius`,
  ),
  new DailyQuoteModel(
    9,
    `What you get by achieving your goals is not as important as what you become by achieving your goals`,
    `Zig Ziglar`,
  ),
  new DailyQuoteModel(
    10,
    `Believe you can and you're halfway there`,
    `Theodore Roosevelt`,
  ),
  new DailyQuoteModel(
    11,
    `You miss 100% of the shots you don't take`,
    `Wayne Gretzky`,
  ),
  new DailyQuoteModel(
    12,
    `Fall seven times and stand up eight`,
    `Japanese Proverb`,
  ),
  new DailyQuoteModel(
    13,
    `Success is not final, failure is not fatal: it is the courage to continue that counts`,
    `Winston Churchill`,
  ),
  new DailyQuoteModel(
    14,
    `In the middle of every difficulty lies opportunity`,
    `Albert Einstein`,
  ),
  new DailyQuoteModel(
    15,
    `It always seems impossible until it's done`,
    `Nelson Mandela`,
  )
];