addEventListener("message",(e)=>{
    let data = e.data;

    if(data.action == true){
        $("#main-container").fadeIn();
        $("#main-container").html("");
        for(const vehicle of data.vehicleInfo){
            let html = `
            <div data-view=${vehicle.model} class="vehicle">
                <div class="vehicle-name">${vehicle.label}</div>
                <div class="vehicle-description">${vehicle.description}</div>
                <div class="vehicle-price">$${vehicle.normalPrice.toLocaleString()}</div>
                <div class="vehicle-icon" data-model=${vehicle.model} data-model=${vehicle.label} data-model=${vehicle.description} data-price=${vehicle.normalPrice} data-index=${data.index}><i class="fas fa-dollar-sign"></i></div>
            </div>
            `
            $("#main-container").append(html);
        }
        $(".vehicle-icon").click(function() {
            let model = $(this).data("model");
            let label = $(this).data("label");
            let description = $(this).data("description");
            let price = Number($(this).data("price"));
            let index = $(this).data("index");
            // $("#main-container").fadeOut()
            $.post("https://arp-aircraft/buy",JSON.stringify({model,label,description,price,index}));
        
        })
        let lastmodel = 0;

        $(".vehicle").click(function() {
            let model = $(this).data("view");
            if(lastmodel != model){
                lastmodel = model
                $.post("https://arp-aircraft/showVeh",JSON.stringify({model}));
            }
        })
    } else if(data.action == "close") {
        $("#main-container").fadeOut()
        $.post("https://arp-aircraft/close",JSON.stringify({}));
    }
})


document.onkeydown = (e) =>{
    let key = e.key;
    if(key == "Escape"){

        $("#main-container").fadeOut()
        $.post("https://arp-aircraft/close",JSON.stringify({}));
    }
}