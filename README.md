# Deep-time Palaeogeography in R <img src="doc/images/PalAss_Erlangen_2024.jpg" align="right" width="200" />

Material for the workshop at the [Annual Meeting of the Palaeontological Association (2024, Erlangen)](https://www.palass.org/meetings-events/annual-meeting/2024/annual-meeting-2024-erlangen-germany-overview)

Ádám T. Kocsis and Elizabeth M. Dowding

## Depedendencies

The material here is dependent on the following software and their dependencies (checked with the given version numbers):
- [R](https://www.r-project.org/) (v4.4.2)
- Functions from the namespaces of these packages will be used:
  - [rgplates](https://gplates.github.io/rgplates) (v0.5.0): 
  - [terra](https://rspatial.github.io/terra/) 
  - [chronosphere](https://chronosphere.info/r_client/)
  - [via](https://adamtkocsis.com/via/)
  - [sf](https://r-spatial.github.io/sf/) 
- Additional packages that need to be installed:
  - geojsonsf
  - httr2 
  - ncdf4 
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
