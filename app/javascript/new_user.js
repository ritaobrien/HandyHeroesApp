document.addEventListener("turbo:load", function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });

    const countyToTowns = {
        'Antrim': ['Antrim Town', 'Ballymena', 'Carrickfergus', 'Larne', 'Newtownabbey'],
        'Armagh': ['Armagh City', 'Newry', 'Lurgan', 'Portadown', 'Craigavon'],
        'Carlow': ['Carlow Town', 'Bagenalstown', 'Hacketstown', 'Leighlinbridge', 'Tullow'],
        'Cavan': ['Cavan Town', 'Virginia', 'Bailieborough', 'Kingscourt', 'Ballyjamesduff'],
        'Clare': ['Ennis', 'Shannon', 'Kilrush', 'Newmarket-on-Fergus', 'Kilkee'],
        'Cork': ['Cork City', 'Cobh', 'Youghal', 'Fermoy', 'Mallow'],
        'Derry': ['Derry City', 'Coleraine', 'Limavady', 'Magherafelt', 'Portstewart'],
        'Donegal': ['Letterkenny', 'Buncrana', 'Ballybofey', 'Carndonagh', 'Donegal Town'],
        'Down': ['Bangor', 'Dundonald', 'Lisburn', 'Newry', 'Newtownards'],
        'Dublin': ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D6W', 'D7', 'D8', 'D9', 'D10', 'D11', 'D12', 'D13', 'D14', 'D15', 'D16', 'D17', 'D18', 'D20', 'D22', 'D24'],
        'Fermanagh': ['Enniskillen', 'Lisnaskea', 'Ballinamallard', 'Irvinestown', 'Kesh', 'Lisbellaw'],
        'Galway': ['Ardrahan', 'Kinvara', 'Oranmore'],
        'Kerry': ['Tralee', 'Killarney', 'Dingle'],
        'Kildare': ['Naas', 'Sallins', 'Rathangan'],
        'Kilkenny': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Laois': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Leitrim': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Limerick': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Longford': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Louth': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Mayo': ['Crossmolina', 'Ballina', 'Achill'],
        'Meath': ['Dunshaughlin', 'Town 1B', 'Town 1C'],
        'Monaghan': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Offaly': ['Tullamore', 'Town 1B', 'Town 1C'],
        'Roscommon': ['Roscommon Town', 'Town 1B', 'Town 1C'],
        'Sligo': ['Sligo Town', 'Town 1B', 'Town 1C'],
        'Tipperary': ['Cloughjordan', 'Tipperary Town', 'Cashel'],
        'Tyrone': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Waterford': ['Waterford City', 'Tramore', 'Town 1C'],
        'Westmeath': ['Town 1A', 'Town 1B', 'Town 1C'],
        'Wexford': ['Wexford Town', 'Rosslare', 'Kilmore Quay'],
        'Wicklow': ['Glendalough', 'Greystones', 'Wicklow Town']
    };

    const countySelect = document.getElementById('user_county');
    const townSelect = document.getElementById('town_select');
    const volunteerDocs = document.getElementById("volunteer-docs");
    const roleField = document.getElementById("role-field");

    // Populate towns based on selected county
    countySelect.addEventListener('change', function() {
        const selectedCounty = countySelect.value;

        // Clear current town options
        townSelect.innerHTML = '<option value="">Select Nearest Area</option>';

        if (selectedCounty && countyToTowns[selectedCounty]) {
            // Populate town options based on selected county
            countyToTowns[selectedCounty].forEach(function(town) {
                const option = document.createElement('option');
                option.value = town;
                option.text = town;
                townSelect.add(option);
            });
        }
    });

    // Handle role selection (Senior or Volunteer)
    document.querySelectorAll('.role-image').forEach(item => {
        item.addEventListener('click', event => {
            const selectedRole = event.target.dataset.role;
            roleField.value = selectedRole;

            // Show or hide volunteer docs section based on selected role
            if (selectedRole === "volunteer") {
                volunteerDocs.style.display = "block";
            } else {
                volunteerDocs.style.display = "none";
            }

            // Add styling to highlight selected role
            document.querySelectorAll('.role-image').forEach(image => {
                image.classList.remove('selected');
            });
            item.classList.add('selected');
        });
    });
});