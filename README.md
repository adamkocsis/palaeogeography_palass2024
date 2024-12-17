# Deep-time Palaeogeography in R <img src="doc/images/PalAss_Erlangen_2024.jpg" align="right" width="200" />

Material for the workshop at the [Annual Meeting of the Palaeontological Association (2024, Erlangen)](https://www.palass.org/meetings-events/annual-meeting/2024/annual-meeting-2024-erlangen-germany-overview)

*Ádám T. Kocsis and Elizabeth M. Dowding*

**2024-12-10**

See `doc/DeepTimePRPalass.pptx` for the slides. You can also access the slides on [Google](https://docs.google.com/presentation/d/1OkxWrQyLD_bGTg43Vcx6f8v8h9G-fm-2/edit?usp=drive_link&ouid=112055272057917681515&rtpof=true&sd=true). 

## Depedendencies

The material here is dependent on the following software and their dependencies (checked with the given version numbers):
- [R](https://www.r-project.org/) (v4.4.2)
- Functions from the namespaces of these packages will be used:
  - [rgplates](https://gplates.github.io/rgplates) (v0.5.0): Used for tectonic reconstructions.
  - [terra](https://rspatial.github.io/terra/) (v1.7-78): Used for raster spatial calculations.
  - [chronosphere](https://chronosphere.info/r_client/) (v0.6.1): Used to access data items.
  - [via](https://adamtkocsis.com/via/) (v0.2.0): Used for organizing reconstruction products.
  - [sf](https://r-spatial.github.io/sf/) (v1.0-16): Vector spatial data, direct dependency of `rgplates`.
- Additional packages that need to be installed:
  - [geojsonsf](https://cran.r-project.org/package=geojsonsf)(v2.0.3): Used by `rgplates`.
  - [httr2](https://httr2.r-lib.org/) (v1.0.0): Used by `rgplates`.
  - [ncdf4](https://cran.r-project.org/package=ncdf4) (v1.22): Used to read in netcdf files (for `terra`).
- [GPlates Web Service](https://gwsdoc.gplates.org/) (v0.2.0): The web service needs to be online for the examples to work. If the web service is down, you can [run it locally with Docker](https://github.com/GPlates/gplates-web-service/blob/master/docker/README.md). In this case you have to use `?rgplates::setgws` in R for using this with `rgplates`. 
- [GPlates Desktop Application](https://www.earthbyte.org/download-gplates-2-5/) (v2.5.0)
  
All the R packages can be installed with:

``` R
install.packages(c("rgplates", "terra", "chronosphere", "via", "sf", "geojsonsf", "httr2", "ncdf4"))
```
  
## Instructions 
 
1. Clone the repository or download it as a zip file and extract it.
2. Examples are in the `code` directory. Set the working directory to be the path of the `palaeogeography_palass2024` directory. The examples are numbered in the order in which you are suggested to check them out: 
  - `1_explore.R`: Exploring plate tectonic models with `rgplates`
  - `2_pointData.R`: Using point spatial data with tectonic models.
  - `3_reconstruction_products.R`: Examples showing how to approach paleogeographic reconstructions that are based on specific tectonic reconstructions.
3. After the last tutorial script, you are welcome to check out the code that is used to create this demonstration figure below (see link at the end of [this paragraph](https://gplates.github.io/rgplates/#using-reconstructions)). 

![](doc/images/temperature.png)



## Additional external links

- Additional tutorials about `rgplates` can be found on the [website of the package](https://gplates.github.io/rgplates).
