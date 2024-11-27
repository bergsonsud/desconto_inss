WickedPdf.config ||= {}
WickedPdf.config.merge!({
                          layout: "pdf.html.erb",
                          orientation: "Landscape", # Portrait
                          page_size: "A4",
                          lowquality: true,
                          zoom: 1,
                          dpi: 75,
                          encoding: 'UTF-8'
                        })
