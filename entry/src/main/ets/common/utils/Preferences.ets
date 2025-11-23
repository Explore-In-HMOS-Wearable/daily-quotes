import preferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';

const PREFERENCES_NAME = 'favourites.db';
let favouritesPreferences: preferences.Preferences | null = null;
let context: Context = AppStorage.get('context') as Context;

@Observed
export default class Preferences {
  static instance = new Preferences();
  favourites: number[] = [];

  constructor() {
    this.initialize();
  }

  async initialize() {
    await this.getPreferencesFromStorage();
    this.favourites = this.getPreference();
  }

  async getPreferencesFromStorage() {
    favouritesPreferences = await preferences.getPreferences(context, PREFERENCES_NAME);
  }

  async on(callback: Callback<Record<string, preferences.ValueType>>) {
    favouritesPreferences?.on('dataChange', ['favourites'], callback);
  }

  async off() {
    favouritesPreferences?.off('dataChange', ['favourites']);
  }

  putPreference(data: number[]) {
    if (favouritesPreferences !== null) {
      favouritesPreferences.putSync('favourites', data);
      favouritesPreferences.flush();
    }
  }

  getPreference(): number[] {
    let favourites: number[] = [];
    if (favouritesPreferences !== null) {
      favourites = favouritesPreferences.getSync('favourites', []) as number[];
    }
    return favourites;
  }
}
