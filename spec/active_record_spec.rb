require 'spec_helper'

describe Sortable::ActiveRecord do
  
  it 'should have a sortable class method' do
    Quote.methods.include?(:sortable).should be_true
  end
  
  it 'should have a sort class method' do
    Quote.methods.include?(:sort).should be_true
  end
  
  describe '.sortable' do
  
    shared_examples_for 'sort_columns_defined' do
      it 'should set the sort_columns options for the specified sort name' do
        Quote.sort_columns.should have_key(sort_name)
      end
      
      describe 'sort_columns for the specified sort name' do
        it 'should properly set the column_name option' do
          Quote.sort_columns[sort_name][:column_name].should == column_name_option
        end
        
        it 'should properly set the default option' do
          Quote.sort_columns[sort_name][:default].should == default_option
        end
        
        it 'should properly set the joins option' do
          Quote.sort_columns[sort_name][:joins].should == joins_option
        end
        
        it 'should properly set the clause option' do
          Quote.sort_columns[sort_name][:clause].should == clause_option      
        end
      end
    end
    
    context 'given no parameters' do
      before(:each) do
        Quote.sortable()
      end
    
      it 'should set sort_columns to an empty hash' do
        Quote.sort_columns.should == {}
      end
      
      it 'should set default_sort_columns to an empty hash' do
        Quote.default_sort_columns.should == {}
      end
    end
    
    context 'given a sort column with just the required sort options' do
      let!(:sort_name)          { :price }
      let!(:column_name_option) { :price }
      let!(:default_option)     { nil }
      let!(:joins_option)       { nil }
      let!(:clause_option)      { "quotes.price" }
    
      before(:each) do
        Quote.sortable sort_name => {:column_name => column_name_option}
      end
      
      it_should_behave_like 'sort_columns_defined'
      
      it 'should set default_sort_columns to an empty hash' do
        Quote.default_sort_columns.should == {}
      end
    end
    
    context 'given a sort column with a default specified in the sort options' do
      let!(:sort_name)          { :price }
      let!(:column_name_option) { :price }
      let!(:default_option)     { 'DESC' }
      let!(:joins_option)       { nil }
      let!(:clause_option)      { "quotes.price" }
    
      before(:each) do
        Quote.sortable sort_name => {:column_name => column_name_option, :default => default_option}
      end
      
      it_should_behave_like 'sort_columns_defined'
      
      it 'should set the default_sort_columns options for the specified sort name' do
        Quote.default_sort_columns.should have_key(sort_name)
      end
      
      it 'should set the clause of the default_sort_columns for the specified sort name' do
        Quote.default_sort_columns[sort_name].should == "#{clause_option} #{default_option}"
      end
    end
    
    context 'given a sort column with a joins specified in the sort options' do
      let!(:sort_name)          { :product_name }
      let!(:column_name_option) { :name }
      let!(:default_option)     { nil }
      let!(:joins_option)       { :product }
      let!(:clause_option)      { "products.name" }

      before(:each) do
        Quote.sortable sort_name => {:column_name => column_name_option, :joins => joins_option}
      end
      
      it_should_behave_like 'sort_columns_defined'
      
      it 'should set default_sort_columns to an empty hash' do
        Quote.default_sort_columns.should == {}
      end
    end
  end
  
  describe '.sort' do
  
  end
  
end
