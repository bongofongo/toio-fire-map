import pandas as pd

def filter_long_lat (df, long_min, long_max, lat_min, lat_max):

    # filter out entries outside of long_min/mac and lat_min/max
    filtered_df = df[(df['longitude'] >= long_min) & (df['longitude'] <= long_max) & 
                    (df['latitude'] >= lat_min) & (df['latitude'] <= lat_max)]

    return filtered_df

def filter_confidence(df, is_numeric):
    
    #if we're filtering numbers keep confidence above 50 otherwise keep not low confofence level
    if is_numeric:
        return df[df['confidence'] >= 50]
    else:
        return df[df['confidence'] != 'low']

def frp_to_brightness(frp):
    if frp >= 1000:
        return 10
    elif 850 <= frp < 1000:
        return 9
    elif 700 <= frp < 850:
        return 8
    elif 550 <= frp < 700:
        return 7
    elif 400 <= frp < 550:
        return 6
    elif 250 <= frp < 400:
        return 5
    elif 100 <= frp < 250:
        return 4
    elif 50 <= frp < 100:
        return 3
    elif 10 <= frp < 50:
        return 2
    elif 0 < frp < 10:
        return 1
    else:  # frp == 0
        return 0

# landstat_df = pd.read_csv("data/landstat.csv")
modis_df = pd.read_csv("data/modis.csv")
noaa20_df = pd.read_csv("data/noaa20.csv")
noaa21_df = pd.read_csv("data/noaa21.csv")
snip_df = pd.read_csv("data/snip.csv")

# dfs = [landstat_df, modis_df, noaa20_df, noaa21_df, snip_df]
dfs = [modis_df, noaa20_df, noaa21_df, snip_df]
filtered_dfs = []

for df in dfs:
    #filter out long and lat outside of continous USA
    filtered_df = filter_long_lat(df, -125, -65, 25, 50)

    #filiter out low confidence (if df is modis use numerical filter)
    filtered_df = filter_confidence(filtered_df, df is modis_df)

    #add it to the list of filtered dfs
    filtered_dfs.append(filtered_df)

final_df = pd.concat(filtered_dfs, ignore_index=True)
final_df['brightness'] = final_df['frp'].apply(frp_to_brightness)

final_df['date_and_time'] = pd.to_datetime(final_df['acq_date'] + ' ' + final_df['acq_time'].astype(str).str.zfill(4), format='%Y-%m-%d %H%M')
final_df = final_df.sort_values(by='date_and_time', ascending=True)

final_df = final_df[['latitude', 'longitude', 'brightness', 'acq_date', 'acq_time']]

final_df.to_csv('sketch/filtered_file.csv', index=False)

print("Filtering complete. Saved as 'sketch/filtered_file.csv'.")

