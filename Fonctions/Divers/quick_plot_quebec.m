function quick_plot_quebec(varargin)
load('DATA_QUEBEC.mat');
hold on;
box on;
%grid on;

n = nargin;
if n == 0
    % Valeurs par défaut
    plot_info.sup_lacs_min = .001;
    plot_info.sup_iles_min = .01;
    
    plot_info.couleur_face_lacs = [0.8 0.9 1.0];
    plot_info.couleur_contour_lacs = [0.75 0.85 1.0];
    
    plot_info.couleur_contour_iles = [0.75 0.85 1.0];
    
    plot_info.couleur_face_masque = [0.75 0.75 0.75];
    plot_info.couleur_contour_masque = 'none';
    
    plot_info.precision = 20;
    plot_info.masquer_lignes = 1;
else
    
    plot_info = varargin{1};
    
end

for m = 1 :length(MASQUE)
    NP = numel(MASQUE(m).X);
    ind = [1:10 6:plot_info.precision:NP-6 NP-10:NP];
    p = patch(MASQUE(m).X(ind),MASQUE(m).Y(ind),-3*ones(size(MASQUE(m).Y(ind))),[1 1 1],'tag','masque');
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
      set(p,'facecolor',plot_info.couleur_face_masque,'edgecolor',plot_info.couleur_contour_masque,'linewidth',0.25);
      
end

for l = 1 : length(LACS);
    if LACS(l).SUPERFICIE >= plot_info.sup_lacs_min
        
        NP = numel(LACS(l).X);
        if NP >= 20
            
            if l == 3
                ind = unique(sort([1:10 6:plot_info.precision:NP-6 NP-10:NP 5775:5777]));
            else
                ind = [1:10 6:plot_info.precision:NP-6 NP-10:NP];
            end
        else
            ind = 1:NP;
        end
        
        p = patch(LACS(l).X(ind),LACS(l).Y(ind),-2*ones(size(LACS(l).Y(ind))),[1 1 1],'tag','lacs');
          set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');      
        set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_contour_lacs,'linewidth',0.25);
    end
end

for i = 1 : length(ILES)
    
    if ILES(i).SUPERFICIE >= plot_info.sup_iles_min
        
        % La couleur de l'iles dépend si elle tombe ou non dans le masque;
        if ILES(i).IN_MASK == 1
            couleur_face_iles = plot_info.couleur_face_masque;
        else
            couleur_face_iles = get(gca,'color');
        end
        
        NP = numel(ILES(i).X);
        if NP >= 30
            ind = [1:10 6:plot_info.precision:NP-6 NP-10:NP];
        else
            ind = [1:NP];
        end
        
        try
            p = patch(ILES(i).X(ind),ILES(i).Y(ind),10*ones(size(ILES(i).Y(ind))),[1 1 1],'tag','iles');
            set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        catch
            disp('bug');
        end
        set(p,'facecolor',couleur_face_iles,'edgecolor',plot_info.couleur_contour_iles,'linewidth',0.25);

      
    end
end

xlim([-80 -53]);
ylim([45 65]);
daspect([1.6 1 1]);


if plot_info.masquer_lignes == 1;
    % Masquer les lignes
    % Patch 1
    dx =  0.0002;
    dy = (1/3.1364)*dx;
    p = patch([-67.3789-dx -67.3789+dx -66.6860+dx -66.6860-dx],[49.3176-dy 49.3176+dy 49.0991+0.4*dy 49.0991-0.4*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
      set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
      
    p1 = [-82.2538+0.0005 55.1096];
    p2 = [-79.7625-0.0005 54.6321];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+2*dx p2(1)+dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-64.8382 61.3085-0.0005];
    p2 = [-64.8359 60.4852+0.0005];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    p1 = [-69.4995+0.0005 61.0643];
    p2 = [-64.8359-0.0005 60.4852];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-80.1322+0.0002 63.7709];
    p2 = [-77.5123-0.0002 62.5811];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-69.7167+0.0001 48.1200-0.0001];
    p2 = [-69.4709-0.0001 48.0062+0.0001];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+0.2*dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-0.2*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-69.7169 48.1344-0.0001];
    p2 = [-69.7171 48.1238+0.0001];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+0.2*dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-0.2*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-69.4618+0.0001 48.0020-0.0001];
    p2 = [-69.4386-0.0001 47.9913+0.0001];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+0.2*dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-0.2*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-70.8087+0.0001 47.0494-0.0001];
    p2 = [-70.7122-0.0001 46.9355+0.0001];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+0.2*dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-0.2*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-56.9984+0.0001 51.4166-0.0001];
    p2 = [-56.7875-0.0001 51.2501+0.0001];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+0.2*dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-0.2*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    p1 = [-60.3952+0.0001 47.0304+0.0001];
    p2 = [-59.2295-0.0001 47.5832-0.0001];
    a = (p1(2)-p2(2)) / (p1(1)-p2(1));
    dx =  0.0002;
    dy = (1/a)*dx;
    p = patch([p1(1)-dx p1(1)+dx p2(1)+0.2*dx p2(1)-dx],[p1(2)-dy p1(2)+dy p2(2)+dy p2(2)-0.2*dy],-[1.5 1.5 1.5 1.5]*1,[1 1 1],'tag','patch');
    set(p,'facecolor',plot_info.couleur_face_lacs,'edgecolor',plot_info.couleur_face_lacs,'linewidth',2);
     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
     
    set(gca,'Layer','top');
end
%set(gcf,'Renderer','opengl')
end

