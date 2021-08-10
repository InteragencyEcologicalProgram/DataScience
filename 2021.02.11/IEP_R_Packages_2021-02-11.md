### IEP Relevant R Packages

1. [zooper](https://github.com/InteragencyEcologicalProgram/zooper)  
    * Author: Sam Bashevkin  
    * Download and Integrate Zooplankton Datasets from the Upper San Francisco Estuary   
    * Includes data from 5 major IEP zooplankton surveys and 3 size classes of zooplankton  
    * Can integrate data and resolve taxonomy for users interested in analyzing specific taxa or whole communities  
    * Also has a shiny app, which includes a visualization tool  
    * Download package from GitHub  
2. [deltamapr](https://github.com/InteragencyEcologicalProgram/deltamapr)   
    * Author: Sam Bashevkin  
    * Package of spatial data for the Bay-Delta   
    * Includes shapefiles for three types of data:  
      * Waterways (i.e., water coverage)  
      * Regions from Enhanced Delta Smelt Monitoring Program  
      * Surface water and riparian areas based on California Aquatic Resources Inventory
    * Download package from GitHub  
3. [spacetools](https://github.com/sbashevkin/spacetools)
    * Author: Sam Bashevkin  
    * Tools for spatial operations  
      * Ex: calculating distances along waterways
    * Functionality is focused on aquatic systems and particularly the Sacramento San Joaquin Delta 
    * But the functions should be useful for other systems as well.
    * Download package from GitHub
4. [smonitr](https://github.com/InteragencyEcologicalProgram/smonitr)
    * Authors: Michael Koohafkan, David Bosworth 
    * Used to build the IEP Seasonal Monitoring Reports
    * Helps download various IEP datasets including those on the following platforms:
      * Bay-Delta Live
      * Environmental Data Initiative (EDI)
      * SacPAS salmon data
      * FTP sites (e.g., many CDFW data sets)  
    * Download package from GitHub
5. [cder](https://github.com/mkoohafkan/cder) 
    * Author: Michael Koohafkan
    * Interface to the California Data Exchange Center (CDEC) Web Service
    * CDEC hosts a variety of hydrologic and climate data
    * Package streamlines data exploration and downloading
    * Note: CDEC generally contains raw data. Contact data maintainers for QAQC versions.
    * Download package from Comprehensive R Archive Network (CRAN)
6. [CDECRetrieve](https://github.com/FlowWest/CDECRetrieve/)
    * Author: FlowWest
    * another package for exploring and downloading CDEC data
    * Download package from GitHub
7. [CDECRetrieveGUI](https://github.com/fishsciences/CDECRetrieveGUI)
    * Author: Cramer Fish Sciences
    * A map-based interface to the CDECRetrieve package.
    * Download package from GitHub.
8. [cimir](https://github.com/mkoohafkan/cimir)  
    * Author: Michael Koohafkan
    * Interface to the California Irrigation Management Information System (CIMIS) Web API
    * CIMIS is source for lots of environmental data related to agriculture
    * Package streamlines data exploration, downloading, and reformatting
    * Note: need a CIMIS account and to request a web services AppKey before using this package
    * Download package from CRAN
9. [wql](https://github.com/jsta/wql)  
    * Authors: Alan Jassby, James Cloern, Joseph Stachelek
    * Functions for exploring seasonal time series, particularly for water quality data
    * Creates exploratory time series plots 
    * Runs nonparametric trend tests (e.g., Mann-Kendall trend test)
    * Downloads USGS water quality data for San Francisco Bay
    * Has functions to convert among units
    * Electrical conductivity to salinity
    * DO in mg/L to % saturation
    * Download package from CRAN
10. [dataRetrieval](https://github.com/USGS-R/dataRetrieval/)  
    * Authors: Laura DeCicco et al
    * Explore and download hydrologic and water quality data
    * USGS National Water Information System (NWIS)
    * Water Quality Portal (includes USGS, EPA, USDA)
    * Download package from CRAN
11. [caladaptR](https://github.com/ucanr-igis/caladaptr/)     
    * makes it easier to work with data from Cal-Adapt.org 
    * package downloads data for use in R
    * Cal-Adapt houses historical data and projections for how climate change will affect CA
    * includes data on a variety of environmental variables, including:
      * temperature
      * snowpack
      * sea level rise
      * wildfires
    * Download package from GitHub
12. [artemis](https://github.com/fishsciences/artemis)    
    * Author: Myfanwy Johnston, Matt Espe
    * Aids design and analysis of environmental DNA (eDNA) survey studies
    * Offers custom suite of models for quantitative polymerase chain reaction (qPCR) data from extracted eDNA samples
    * Approach makes use of Bayesian truncated latent variable models 
    * Download package from GitHub
13. [waterYearType](https://github.com/FlowWest/waterYearType/)    
    * Author: Sadie Gill 
    * Sacramento and San Joaquin Valley Water Year Types
    * Data from CA Dept. of Water Resources
    * Based on measured unimpaired runoff
    * Download package from CRAN
