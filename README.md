# toio-fire-map
## Downloading and Filtering most recent data
- To download newest data run the command `bash download-data.sh` in directory with data-filter.py file
- To filter the new data run the command `python3 data-filter.py` make sure to run `pip install pandas` if pandas is not already loaded in 
## Connecting to TOIOs
- `cd '/Users/charles/Documents/Dev.nosync/MPCS_Chi/AxLab/Laptop-TOIO/rust_osc'`
- `cargo run -- -a 33,36,85,132,137,143,158,165`
## Projection Mapping
- use `c,l,s` to calibrate, load, and save maps.