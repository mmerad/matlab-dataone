classdef GeographicCoverage < handle
    properties
        geographicDescription;
        boundingCoordinates;
        datasetGPolygon;
        boundingAltitudes;
        references;
        id;
        system;
        scope;        
    end
    
    methods
        function this = GeographicCoverage()            
        end
        
        function this = setBoundingCoordinates(this, west, east, north, south) 
            this.boundingCoordinates = struct('westBoundingCoordinate', west, 'eastBoundingCoordinate', east, 'northBoundingCoordinate', north, 'southBoundingCoordinate', south);

        end
        
        function this = setGeographicDescription(this, geo_desc)
            this.geographicDescription = geo_desc;
        end
        
        function this = setDataSetGPolygon()
            
        end
        
        function this = setBoundingAltitudes(this, altitudeMinimum, altitudeMaximum, altitudeUnits)
            this.boundingAltitudes = struct('altitudeMinimum', altitudeMinimum, 'altitudeMaximum', altitudeMaximum, 'altitudeUnits', altitudeUnits);
        end
        
        function geo_coverage_map = getNestedMap(this)
           
            if isempty(this) 
                return;
            end
            
            fields = fieldnames(this);
            valueSet = cell(1, length(fields));
            keySet = cell(1, length(fields));
            
            for i = 1 : length(fields)
               value = this.(fields{i});
               if isa(value, 'struct') == 0 
                   keySet{i} = fields{i};
                   valueSet{i} = value;
               else
                   anStruct = struct(value);
                   anMap = containers.Map(fieldnames(anStruct), struct2cell(anStruct));
                   keySet{i} = fields{i};
                   valueSet{i} = anMap;
               end
            end
            geo_coverage_map = containers.Map(keySet, valueSet);
        end
        
        function dom_node = convert2DomNode(this, anMap, dom_node, document)
            if isempty(dom_node)
                document = com.mathworks.xml.XMLUtils.createDocument('rootNode');                
                documentNode = document.getDocumentElement();
                dom_node = document.createElement('GeographicCoverage');
                documentNode.appendChild(dom_node);
            end

            keySet = anMap.keys;
            valueSet = anMap.values;
            for i = 1: length(keySet)
                ele_node = document.createElement(keySet{i});   
                dom_node.appendChild(ele_node);
                if isa(valueSet{i}, 'containers.Map') == 0
                   if isnumeric(valueSet{i}) == 1
                       ele_node_text_node = document.createTextNode(num2str(valueSet{i}));
                   else    
                       ele_node_text_node = document.createTextNode(char(valueSet{i}));
                   end
                   ele_node.appendChild(ele_node_text_node);                   
                else
                   copy_ele_node = ele_node;
                   dom_node = convert2DomNode(this, valueSet{i}, copy_ele_node, document); 
                end              
            end         
        end
    end
end
    
