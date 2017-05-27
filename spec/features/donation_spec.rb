RSpec.feature "Donations", type: :feature do
  before :each do
    sign_in @user
    @url_prefix = "/#{@organization.short_name}"
  end

  context "When visiting the index page" do
    before(:each) do
      visit @url_prefix + "/donations"
    end

    scenario "User can click to the new donation form" do
      click_link "New Donation"

      expect(current_path).to eq(new_donation_path(@organization))
      expect(page).to have_content "Start a new donation"
    end
  end

  context "When creating a new donation" do
    before(:each) do
      create(:item)
      create(:dropoff_location)
      create(:storage_location)
      
    end

    context "via manual entry" do
      before do
        visit @url_prefix + "/donations/new"
      end

      scenario "User can create a donation for a Diaper Drive source" do
        select "Diaper Drive", from: "donation_source"
        select DiaperDrive.first.name, from: "donation_diaper_drive"
        select StorageLocation.first.name, from: "donation_storage_location_id"
        select Item.alphabetized.first.name, from: "donation_line_items_attributes_0_item_id"
        fill_in "donation_line_items_attributes_0_quantity", with: "5"

        expect {
          click_button "Create Donation"
        }.to change{Donation.count}.by(1)
      end

      scenario "User can create a donation for a Donation Site source" do
        select "Donation Pickup Location", from: "donation_source"
        select DropoffLocation.first.name, from: "donation_dropoff_location_id"
        select StorageLocation.first.name, from: "donation_storage_location_id"
        select Item.alphabetized.first.name, from: "donation_line_items_attributes_0_item_id"
        fill_in "donation_line_items_attributes_0_quantity", with: "5"

        expect {
          click_button "Create Donation"
        }.to change{Donation.count}.by(1)
      end

      scenario "User can create a donation for Purchased Supplies" do
        select "Purchased Supplies", from: "donation_source"
        select StorageLocation.first.name, from: "donation_storage_location_id"
        select Item.alphabetized.first.name, from: "donation_line_items_attributes_0_item_id"
        fill_in "donation_line_items_attributes_0_quantity", with: "5"

        expect {
          click_button "Create Donation"
        }.to change{Donation.count}.by(1)
      end

      scenario "User can create a donation with a Miscellaneous source" do
        select "Misc. Donation", from: "donation_source"
        select StorageLocation.first.name, from: "donation_storage_location_id"
        select Item.alphabetized.first.name, from: "donation_line_items_attributes_0_item_id"
        fill_in "donation_line_items_attributes_0_quantity", with: "5"

        expect {
          click_button "Create Donation"
          save_and_open_page
        }.to change{Donation.count}.by(1)

      end

    end

    context "via barcode entry" do
      before(:each) do
        # create one pre-existing barcode associated with an item
        @existing_barcode = create(:barcode_item)
        @item_with_barcode = @existing_barcode.item
        # create a new item that has no barcode existing for it yet
        @item_no_barcode = create(:item)
      end

      scenario "a user can add items via scanning them in by barcode" do
        # enter the barcode into the barcode field
        # the form should update
        pending("TODO: adding items via an existing barcode")
        raise
      end
  
      scenario "a user can add items that do not yet have a barcode" do
        # enter a new barcode
        # form finds no barcode and responds by prompting user to choose an item and quantity
        # fill that in
        # saves new barcode
        # form updates
        pending "TODO: adding items with a new barcode"
        raise
      end

    end
  end
end
